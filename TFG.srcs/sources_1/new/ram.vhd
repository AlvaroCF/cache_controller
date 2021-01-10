library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.dependencies.all;


entity ram is
	port(
		I_clock:			in	std_logic;
		--I_rst:            in  std_logic;    --nuevo
		I_enable:			in	std_logic;
		I_read_write:		in 	std_logic;
		I_write_enable:     in	std_logic_vector(NB_COL-1 downto 0);
		I_Address:			in	std_logic_vector(ADDRLEN-1 downto 0);
		I_Data:				in	std_logic_vector(XLEN-1 downto 0);
		O_Data:				out	std_logic_vector(XLEN-1 downto 0);
		O_Ready:            out std_logic;
		O_Valid:            out std_logic
	);
end ram;


architecture behavioural of ram is
	signal ram:    ram_type := RAM_INIT;
begin

	process(I_clock)
	begin
	    O_Ready <= '0';
	    O_Valid <= '0';
	    --if(I_rst = '1') then
	       --ram <= RAM_INIT;
		if rising_edge(I_clock) then
			O_Data <= XLEN_ZERO;
			if I_enable = '1' then
				if I_read_write = '0' then
					O_Data	<=	ram(to_integer(unsigned(I_Address)));
					O_Valid <= '1';
			    elsif I_read_write = '1' then
			        for i in 0 to NB_COL-1 loop
					   if I_write_enable(i) = '1' then 
						  ram(to_integer(unsigned(I_Address)))((i+1)*COL_WIDTH-1 downto i*COL_WIDTH)	<= I_Data((i+1)*COL_WIDTH-1 downto i*COL_WIDTH);
					   end if;
				    end loop;
				end if;
				
				O_Ready <= '1';
			end if;
		end if;
	end process;

end behavioural;