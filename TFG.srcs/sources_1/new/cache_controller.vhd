library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.dependencies.all;


entity cache_controller is
    port(
        I_clk :             in std_logic; --entrada del reloj
        I_rst :             in std_logic;   --señal de reset global
        I_act :             in std_logic; -- Valor de activacion
        O_ready_cpu :       out std_logic; --notifica a la CPU de que la petición está lista
        I_w_r :             in std_logic;   --bit que indica si es lectura (0) o escritura (1)
        I_write_enable :    in std_logic_vector(NB_COL-1 downto 0); -- bits que indican que bytes se escriben
        I_address :         in std_logic_vector(XLEN-1 downto 0); --dirección en la que realizar la acción
        I_data_cpu :        in std_logic_vector(XLEN-1 downto 0); --datos aportados por la CPU en casa de escritura
        O_valid_response :  out std_logic; --anuncia que la respuesta otorgada es válida
        O_data_response :   out std_logic_vector(XLEN-1 downto 0)); --datos devueltos a la CPU
        
end cache_controller;

architecture Behavioral of cache_controller is
    
    signal read_write_mem : std_logic := '0'; --bit de lectura/escritura de la ram
    signal address_mem : std_logic_vector(ADDRLEN-1 downto 0); --dirección de los datos para la ram
    signal enable_mem : std_logic_vector(NB_COL-1 downto 0) := "0000";
    signal petition_mem : std_logic_vector(XLEN-1 downto 0) := x"00000000";
    signal answer_mem : std_logic_vector(XLEN-1 downto 0);
    signal req_ready_mem : std_logic;
    signal resp_val_mem : std_logic;
    signal actRAM : std_logic;
 
    signal state : state_type := IDLE;
  
    signal cache_mem	:	memory := (others => (others => '1')); --instanciación de la tabla de datos
    signal cache_table  :   table := (others => (others => '0')); -- instanciación de la tabla de etiquetas
    
begin
ram : entity work.ram --instanciación de la ram
        port map(
            I_clock => I_clk,
            I_enable => actRAM,
            I_read_write => read_write_mem,
            I_write_enable => enable_mem,
            I_Address => address_mem,
            I_Data => petition_mem,
            O_data => answer_mem,
            O_Ready =>  req_ready_mem,
		    O_Valid => resp_val_mem
);
            
               

         
process(I_clk, I_address, I_act, I_w_r,I_rst)
        variable index    : integer; --variable que permite convertir la dirección en integer
    begin
        if(I_rst = '1') then
            cache_table <= (others => ((I_table_size-1) => '0'));
        elsif(I_clk'EVENT AND I_clk = '1') THEN
            if(I_act = '1' or state /= IDLE) then
               index := to_integer(unsigned(I_address(XLEN-1 downto ((XLEN-1)-(COL_WIDTH-1))))); --conversión de la dirección
               if(I_w_r = '1') then --escritura
                    if(state /= WRITE_CACHE) then    --Las escrituras disponen de un estado más que las lecturas, por lo que se establece este bloque así
                        if((cache_table(index)(I_table_size-1) = '1') and (cache_table(index)(I_table_size-3 downto 0) = I_address(I_table_size-1 downto 2))) then  --En caso de ser válido el dato de caché y de coincidir con la entrada, se escribe sin más
                            cache_table(index) <= ('1' & '1' & I_address(I_table_size-1 downto 2)); --mete en la dirección indicada la tag y los bits de valid y dirty a 1 y 1                              
                            for i in 0 to NB_COL-1 loop
                                if I_write_enable(i) = '1' then 
                                    cache_mem(index)((i+1)*COL_WIDTH-1 downto i*COL_WIDTH)  <= I_data_cpu((i+1)*COL_WIDTH-1 downto i*COL_WIDTH);
                                end if;
                            end loop;

                            O_ready_cpu <= '1';
                            O_valid_response <= '0';   --Al no modificar la salida por ser una escritura, la salida pasa a no ser válida

        --  CAMBIAR DE ESTADO: PASAR A IDLE
                            state <= IDLE;

                        else
                            if(cache_table(index)(I_table_size-2) = '1' and state = IDLE) then --Escritura en caso de dirty
                                address_mem <= I_address(XLEN-1 downto ((XLEN-1)-(COL_WIDTH-1))) & cache_table(index)(I_table_size-3 downto I_table_size-4);
                                petition_mem <= cache_mem(index);
                                read_write_mem <= '1';
                                enable_mem <= "1111";

        -- CAMBIAR DE ESTADO: ESCRIBIR EN LA MEMORIA
                                state <= WRITE_MEM;
                                actRAM <= '1';
                            else
                                if (state /= READ_MEM) then
                                    read_write_mem <= '0';  --Lectura de la RAM para obtener el dato que se va a introducir en la caché
                                    address_mem <= I_address(XLEN-1 downto ((XLEN-1)-(COL_WIDTH-1))-2); --dirección de la ram en la que se hará la operación

            -- CAMBIAR DE ESTADO: LEER DE LA MEMORIA
                                    state <= READ_MEM;
                                    actRAM <= '1';
                                end if;
                                if(req_ready_mem = '1' and resp_val_mem = '1') then --Se escribe el dato en caché 
                                    actRAM <= '0';

        -- CAMBIAR DE ESTADO: ESCRIBIR EN LA CACHE
                                    state <= WRITE_CACHE;

                                    cache_table(index) <= ('1' & '0' & I_address(I_table_size-1 downto 2)); --mete en la dirección indicada la tag y los bits de valid y dirty a 1 y 0, respectivamente
                                    cache_mem(index) <= answer_mem; --introduce en la caché los datos

                                end if;
                            end if;
                        end if; 
                    elsif (state = WRITE_CACHE) then    --Una vez se tiene el dato correcto en caché, se sobrescribe de la forma indicada por la CPU
                        cache_table(index) <= ('1' & '1' & I_address(I_table_size-1 downto 2)); --mete en la dirección indicada la tag y los bits de valid y dirty a 1 y 1
                        for i in 0 to NB_COL-1 loop
                            if I_write_enable(i) = '1' then 
                                cache_mem(index)((i+1)*COL_WIDTH-1 downto i*COL_WIDTH)  <= I_data_cpu((i+1)*COL_WIDTH-1 downto i*COL_WIDTH);
                            end if;
                        end loop;

--  CAMBIAR DE ESTADO: PASAR A IDLE
                        state <= IDLE;
                        O_ready_cpu <= '1';
                        O_valid_response <= '0';
                    end if;



               elsif(I_w_r = '0') then --lectura
                    if((cache_table(index)(I_table_size-1) = '1') and (cache_table(index)(I_table_size-3 downto 0) = I_address(I_table_size-1 downto 2))) then
                        O_data_response <= cache_mem(index);   --devuelve los datos solicitados

-- CAMBIAR DE ESTADO: PASAR A IDLE
                        state <= IDLE;
                        O_ready_cpu <= '1';    --La respuesta está lista
                        O_valid_response <= '1';   --La respuesta es válida
                    else    --El bit de validez no está activo o la entrada no coincide con la lectura de caché
                        if(cache_table(index)(I_table_size-2) = '1' and state = IDLE) then --Si el bit de dirty está activo
                                address_mem <= I_address(XLEN-1 downto ((XLEN-1)-(COL_WIDTH-1))) & cache_table(index)(I_table_size-3 downto I_table_size-4);    --Se toman losa 10 primeros bits de la dirección para el índice de la escritura en RAM 
                                petition_mem <= cache_mem(index);  --Se le pasa a la RAM los datos a escribir
                                read_write_mem <= '1';  --Se solicita a la RAM una escritura
                                enable_mem <= "1111";

-- CAMBIAR DE ESTADO: ESCRIBIR EN LA MEMORIA
                                state <= WRITE_MEM;
                                actRAM <= '1';  --Se activa la RAM
                        else
                            if (state /= READ_MEM) then
                                read_write_mem <= '0';  --Se solicita una lectura a la RAM para ver el dato que debe ir a la posición de caché indicada en la petición
                                address_mem <= I_address(XLEN-1 downto ((XLEN-1)-(COL_WIDTH-1))-2); --dirección de la ram en la que se hará la operación

-- CAMBIAR DE ESTADO: LEER DE LA MEMORIA
                                state <= READ_MEM;
                                actRAM <= '1';
                            end if;
                            if (req_ready_mem = '1' and resp_val_mem = '1') then --La RAM ha realizado la lectura
                                actRAM <= '0';  --Se desactiva la RAM
                                cache_table(index) <= ('1' & '0' & I_address(I_table_size-1 downto 2)); --mete en la dirección indicada la tag y los bits de valid y dirty a 1 y 0, respectivamente
                                cache_mem(index) <= answer_mem(XLEN-1 downto 0); --introduce en la caché los datos                              
                                O_data_response <= answer_mem   (XLEN-1 downto 0);

-- CAMBIAR DE ESTADO: PASAR A IDLE
                                state <= IDLE;
                                O_ready_cpu <= '1';     --Respuesta a la CPU lista
                                O_valid_response <= '1';    --Respuesta a la CPU válida
                            end if; 
                        end if;                                                  
                    end if;
               end if;  
           else
                actRAM <= '0';
                O_ready_cpu <= '0';
                O_valid_response <= '0';
           end if;
        end if; 
    end process;


               


end Behavioral;