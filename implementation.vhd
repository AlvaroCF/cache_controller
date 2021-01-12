library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.dependencies_implementation.all;

entity implementation is
    port(
        I_clk               : in std_logic; --entrada del reloj
        I_rst               : in std_logic;
        O_ready             : out std_logic;
        O_valid             : out std_logic;
        O_response          : out std_logic_vector(31 downto 0);
        
        O_data_response     : out std_logic_vector(31 downto 0); 
        O_w_r               : out std_logic;
        O_address           : out std_logic_vector(31 downto 0);
        O_write_enable      : out std_logic_vector(3 downto 0)
    );
        
end implementation;

architecture Behavioral of implementation is

    signal program_counter : integer := 0;
    signal prog : program_arr := program;
    
    signal activation : std_logic;
    signal r_w : std_logic;
    signal we : std_logic_vector(3 downto 0);
    signal addr : std_logic_vector(31 downto 0);
    signal data : std_logic_vector(31 downto 0);
    
    signal ready : std_logic;
    signal valid_response : std_logic;
    signal response : std_logic_vector(31 downto 0);
    
    
    signal clock_ILA: std_logic;
    attribute keep : string;
    attribute keep of  clock_ILA: signal is "true";
begin
     
     clock_ILA <= not I_clk;
               
cache_controller : entity work.cache_controller
    port map(
        I_clk => I_clk,
        I_rst => I_rst,
        I_act => activation,
        O_ready_cpu => ready,
        I_w_r => r_w,
        I_write_enable => we,
        I_address => addr,
        I_data_cpu => data,
        O_valid_response => valid_response,
        O_data_response => response
    
);
   
process(I_clk,I_rst) --proceso principal del controlador
    begin
        if(I_rst = '1') then
            program_counter <= 0;
            activation <= '0';
            r_w <= '0';
            addr <= x"00000000";
            data <= x"00000000";
            we  <= x"0";
            
            O_ready <= ready;
            O_valid <= valid_response;
            O_response <= response;
        elsif rising_edge(I_clk) THEN  
            activation <= program(program_counter).valids;
            r_w <= program(program_counter).read_write;
            addr <= program(program_counter).addresses;
            data <= program(program_counter).data;
            we <= program(program_counter).write_enable;
            program_counter <= program_counter + 1; 
            
            O_ready <= ready;
            O_valid <= valid_response;
            O_response <= response;
        end if;
    end process;
    
    O_data_response    <= data; --datos devueltos a la CPU
    O_w_r              <= r_w;
    O_address          <= addr;
    O_write_enable     <=  we;

end Behavioral;
