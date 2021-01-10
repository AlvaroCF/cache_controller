library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity cache_controller_tb is
--  Port ( );
end cache_controller_tb;

architecture Behavioral of cache_controller_tb is
    component cache_mem
    port(
        I_clk   : in std_logic;
        I_rst   : in std_logic;
        O_ready_cpu : out std_logic;
        I_w_r : in std_logic;
        I_address : in std_logic_vector(31 downto 0);
        I_data_cpu : in std_logic_vector(7 downto 0);
        O_valid_response : out std_logic;
        O_data_response : out std_logic_vector(7 downto 0));
    end component;
    
        signal I_clk_i : std_logic := '0';
        signal I_rst_i : std_logic := '0';
        signal I_act_i : std_logic := '0';
        signal O_ready_cpu_i : std_logic := '0';
        signal I_w_r_i : std_logic := '0';
        signal I_write_enable_i : std_logic_vector(3 downto 0);
        signal I_address_i : std_logic_vector(31 downto 0);
        signal I_data_cpu_i : std_logic_vector(31 downto 0);
        signal O_valid_response_i : std_logic;
        signal O_data_response_i : std_logic_vector(31 downto 0);
        constant clk_period : time := 20 ns;
begin
    DUT: entity work.cache_controller
        port map(
            I_clk => I_clk_i,
            I_rst => I_rst_i,
            I_act => I_act_i,
            O_ready_cpu => O_ready_cpu_i,
            I_w_r => I_w_r_i,
            I_write_enable => I_write_enable_i,
            I_address => I_address_i,
            I_data_cpu => I_data_cpu_i,
            O_valid_response => O_valid_response_i,
            O_data_response => O_data_response_i);
            
            I_clk_i <= not I_clk_i after clk_period;
     process
        begin
            I_rst_i <= '0';
            I_write_enable_i <= "0001";
            I_act_i <= '0';
            wait for 210 ns;
            
            I_act_i <= '1','0' after clk_period;  --Pruebas iniciales de lectura sin estar en caché
            I_w_r_i <= '0';
            I_address_i <= x"ACBC2174";
            wait for 200 ns;
            
            I_act_i <= '1','0' after clk_period;
            I_address_i <= x"FBCC00CC";            
            wait for 200 ns;
            
            
            I_w_r_i <= '1';
            I_data_cpu_i <= x"CCCCCCCC";
            I_write_enable_i <= "1010";
            I_act_i <= '1','0' after clk_period;
            I_address_i <= x"ACBC2174";                 --Pruebas de lecturas sí estando ya en caché
            wait for 200 ns;
            
            I_data_cpu_i <= x"AABBCCDD";
            I_write_enable_i <= "0110";
            I_act_i <= '1','0' after clk_period;
            I_address_i <= x"FBCC00CC";
            wait for 200 ns;
            
            I_data_cpu_i <= x"10AA0022";
            I_write_enable_i <= "1000";
            I_act_i <= '1','0' after clk_period;
            I_address_i <= x"FBCC00CC";
            wait for 200 ns;
            
            I_w_r_i <= '0';
            I_act_i <= '1','0' after clk_period;
            I_address_i <= x"BBBB01B8";
            wait for 200 ns;
            
            I_act_i <= '1','0' after clk_period;
            I_address_i <= x"FBCC00CC";
            wait for 200 ns;
            
            I_act_i <= '1','0' after clk_period;
            I_address_i <= x"ACBC2174";  
            wait for 200 ns;
            
            I_act_i <= '1','0' after clk_period;
            I_address_i <= x"AAAA012A";
            wait for 200 ns;
            
            
            I_w_r_i <= '1';
            I_data_cpu_i <= x"12345678";
            I_write_enable_i <= "1011";
            I_act_i <= '1','0' after clk_period;
            I_address_i <= x"ACBC2174";                 --Pruebas de lecturas sí estando ya en caché
            wait for 200 ns;
            
            I_w_r_i <= '0';
            I_act_i <= '1','0' after clk_period;
            I_address_i <= x"0268CAB1";                 --Pruebas de lecturas sí estando ya en caché
            wait for 200 ns;
            
            I_act_i <= '1','0' after clk_period;
            I_address_i <= x"11CAF38D";                 --Pruebas de lecturas sí estando ya en caché
            wait for 200 ns;
            
            I_act_i <= '1','0' after clk_period;
            I_address_i <= x"FBCC00CC";
            wait for 200 ns;
            
            I_w_r_i <= '1';
            I_data_cpu_i <= x"0014CAFE";
            I_write_enable_i <= "0100";
            I_act_i <= '1','0' after clk_period;
            I_address_i <= x"0268CAB1"; 
            wait for 200 ns;
            
            I_w_r_i <= '0';
            I_act_i <= '1','0' after clk_period;
            I_address_i <= x"ACBC2174";                 --Pruebas de lecturas sí estando ya en caché
            wait for 200 ns;
            
            
            I_w_r_i <= '0';
            I_act_i <= '1','0' after clk_period;
            I_address_i <= x"0268CAB1"; 
            wait for 200 ns;
            
            I_w_r_i <= '1';
            I_data_cpu_i <= x"0014CAFE";
            I_write_enable_i <= "0011";
            I_act_i <= '1','0' after clk_period;
            I_address_i <= x"0268CAB1"; 
            wait for 200 ns;
            
            I_w_r_i <= '0';
            I_act_i <= '1','0' after clk_period;
            I_address_i <= x"0268CAB1"; 
            wait for 200 ns;
            
            I_w_r_i <= '1';
            I_data_cpu_i <= x"008865FB";
            I_write_enable_i <= "0111";
            I_act_i <= '1','0' after clk_period;
            I_address_i <= x"FBCC00CC";
            wait for 200 ns;
            
            I_w_r_i <= '0';
            I_act_i <= '1','0' after clk_period;
            I_address_i <= x"FBCC00CC";
            wait for 200 ns;
            
            I_act_i <= '1','0' after clk_period;
            I_address_i <= x"FBAC0000";
            wait for 200 ns;
            
            I_act_i <= '1','0' after clk_period;
            I_address_i <= x"FBCC00CC";
            wait for 200 ns;
            
            I_rst_i <= '1';
            wait for 200 ns;
            
            I_rst_i <= '0';
            I_act_i <= '1','0' after clk_period;
            I_address_i <= x"FBCC00CC";
            wait for 200 ns;
            
            I_w_r_i <= '1';
            I_data_cpu_i <= x"01234567";
            I_write_enable_i <= "1011";
            I_act_i <= '1','0' after clk_period;
            I_address_i <= x"00005555";
            wait for 200 ns;
            
            I_w_r_i <= '0';
            I_act_i <= '1','0' after clk_period;
            I_address_i <= x"00005555";
            wait for 200 ns;
            
            report "FIN CONTROLADO DE LA SIMULACION" severity failure;
        end process;


end Behavioral;
