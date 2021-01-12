
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;


package dependencies_implementation is

constant XLEN        :  integer := 32;
constant YLEN        :  integer := 8;
constant ZLEN        :  integer := 4;
constant NUM_ADDRESS :  integer := 13;
constant NUM_DATA    :  integer := 2;
-- array de vectores de longitud 8 definido en constantes
type valid_type is array(0 to 1) of std_logic;
type w_r_type is array(0 to 1) of std_logic;
type address_type is array(0 to NUM_ADDRESS-1) of std_logic_vector(XLEN-1 downto 0);
type data_type is array(0 to NUM_DATA-1) of std_logic_vector(YLEN-1 downto 0);

type program_types is record
    valids          : std_logic;
    read_write      : std_logic;
    addresses       : std_logic_vector(XLEN-1 downto 0);
    data            : std_logic_vector(XLEN-1 downto 0);
    write_enable    : std_logic_vector(ZLEN-1 downto 0);
end record program_types;

type program_arr is array(0 to 109) of program_types;

constant program : program_arr := (
    ('0','0',x"00000000",x"00000000","0001"),
    ('0','0',x"00000000",x"00000000","0001"),
    ('0','0',x"00000000",x"00000000","0001"),
    ('0','0',x"00000000",x"00000000","0001"),
    ('0','0',x"00000000",x"00000000","0001"),
    
    ('1','0',x"ACBC2174",x"00000000","0001"),
    ('0','0',x"ACBC2174",x"00000000","0001"),
    ('0','0',x"ACBC2174",x"00000000","0001"),
    ('0','0',x"ACBC2174",x"00000000","0001"),
    ('0','0',x"ACBC2174",x"00000000","0001"),
    
    ('1','0',x"FBCC00CC",x"00000000","0001"),
    ('0','0',x"FBCC00CC",x"00000000","0001"),
    ('0','0',x"FBCC00CC",x"00000000","0001"),
    ('0','0',x"FBCC00CC",x"00000000","0001"),
    ('0','0',x"FBCC00CC",x"00000000","0001"),
    
    ('1','1',x"ACBC2174",x"CCCCCCCC","1010"),
    ('0','1',x"ACBC2174",x"CCCCCCCC","1010"),
    ('0','1',x"ACBC2174",x"CCCCCCCC","1010"),
    ('0','1',x"ACBC2174",x"CCCCCCCC","1010"),
    ('0','1',x"ACBC2174",x"CCCCCCCC","1010"),
    
    ('1','1',x"FBCC00CC",x"AABBCCDD","0110"),
    ('0','1',x"FBCC00CC",x"AABBCCDD","0110"),
    ('0','1',x"FBCC00CC",x"AABBCCDD","0110"),
    ('0','1',x"FBCC00CC",x"AABBCCDD","0110"),
    ('0','1',x"FBCC00CC",x"AABBCCDD","0110"),
    
    ('1','1',x"FBCC00CC",x"10AA0022","1000"),
    ('0','1',x"FBCC00CC",x"10AA0022","1000"),
    ('0','1',x"FBCC00CC",x"10AA0022","1000"),
    ('0','1',x"FBCC00CC",x"10AA0022","1000"),
    ('0','1',x"FBCC00CC",x"10AA0022","1000"),
    
    ('1','0',x"BBBB01B8",x"10AA0022","1000"),
    ('0','0',x"BBBB01B8",x"10AA0022","1000"),
    ('0','0',x"BBBB01B8",x"10AA0022","1000"),
    ('0','0',x"BBBB01B8",x"10AA0022","1000"),
    ('0','0',x"BBBB01B8",x"10AA0022","1000"),
    
    ('1','0',x"FBCC00CC",x"10AA0022","1000"),
    ('0','0',x"FBCC00CC",x"10AA0022","1000"),
    ('0','0',x"FBCC00CC",x"10AA0022","1000"),
    ('0','0',x"FBCC00CC",x"10AA0022","1000"),
    ('0','0',x"FBCC00CC",x"10AA0022","1000"),
    
    ('1','0',x"ACBC2174",x"10AA0022","1000"),
    ('0','0',x"ACBC2174",x"10AA0022","1000"),
    ('0','0',x"ACBC2174",x"10AA0022","1000"),
    ('0','0',x"ACBC2174",x"10AA0022","1000"),
    ('0','0',x"ACBC2174",x"10AA0022","1000"),
    
    ('1','0',x"AAAA012A",x"10AA0022","1000"),
    ('0','0',x"AAAA012A",x"10AA0022","1000"),
    ('0','0',x"AAAA012A",x"10AA0022","1000"),
    ('0','0',x"AAAA012A",x"10AA0022","1000"),
    ('0','0',x"AAAA012A",x"10AA0022","1000"),
    
    ('1','1',x"ACBC2174",x"12345678","1011"),
    ('0','1',x"ACBC2174",x"12345678","1011"),
    ('0','1',x"ACBC2174",x"12345678","1011"),
    ('0','1',x"ACBC2174",x"12345678","1011"),
    ('0','1',x"ACBC2174",x"12345678","1011"),
    
    ('1','0',x"0268CAB1",x"12345678","1011"),
    ('0','0',x"0268CAB1",x"12345678","1011"),
    ('0','0',x"0268CAB1",x"12345678","1011"),
    ('0','0',x"0268CAB1",x"12345678","1011"),
    ('0','0',x"0268CAB1",x"12345678","1011"),
    
    ('1','0',x"11CAF38D",x"12345678","1011"),
    ('0','0',x"11CAF38D",x"12345678","1011"),
    ('0','0',x"11CAF38D",x"12345678","1011"),
    ('0','0',x"11CAF38D",x"12345678","1011"),
    ('0','0',x"11CAF38D",x"12345678","1011"),
    
    ('1','0',x"FBCC00CC",x"12345678","1011"),
    ('0','0',x"FBCC00CC",x"12345678","1011"),
    ('0','0',x"FBCC00CC",x"12345678","1011"),
    ('0','0',x"FBCC00CC",x"12345678","1011"),
    ('0','0',x"FBCC00CC",x"12345678","1011"),
    
    ('1','1',x"0268CAB1",x"0014CAFE","0100"),
    ('0','1',x"0268CAB1",x"0014CAFE","0100"),
    ('0','1',x"0268CAB1",x"0014CAFE","0100"),
    ('0','1',x"0268CAB1",x"0014CAFE","0100"),
    ('0','1',x"0268CAB1",x"0014CAFE","0100"),
    
    ('1','0',x"ACBC2174",x"0014CAFE","0100"),
    ('0','0',x"ACBC2174",x"0014CAFE","0100"),
    ('0','0',x"ACBC2174",x"0014CAFE","0100"),
    ('0','0',x"ACBC2174",x"0014CAFE","0100"),
    ('0','0',x"ACBC2174",x"0014CAFE","0100"),
    
    ('1','1',x"0268CAB1",x"0014CAFE","0100"),
    ('0','1',x"0268CAB1",x"0014CAFE","0100"),
    ('0','1',x"0268CAB1",x"0014CAFE","0100"),
    ('0','1',x"0268CAB1",x"0014CAFE","0100"),
    ('0','1',x"0268CAB1",x"0014CAFE","0100"),
    
    ('1','0',x"0268CAB1",x"0014CAFE","0100"),
    ('0','0',x"0268CAB1",x"0014CAFE","0100"),
    ('0','0',x"0268CAB1",x"0014CAFE","0100"),
    ('0','0',x"0268CAB1",x"0014CAFE","0100"),
    ('0','0',x"0268CAB1",x"0014CAFE","0100"),
    
    ('1','1',x"0268CAB1",x"0014CAFE","0011"),
    ('0','1',x"0268CAB1",x"0014CAFE","0011"),
    ('0','1',x"0268CAB1",x"0014CAFE","0011"),
    ('0','1',x"0268CAB1",x"0014CAFE","0011"),
    ('0','1',x"0268CAB1",x"0014CAFE","0011"),
    
    ('1','0',x"0268CAB1",x"0014CAFE","0011"),
    ('0','0',x"0268CAB1",x"0014CAFE","0011"),
    ('0','0',x"0268CAB1",x"0014CAFE","0011"),
    ('0','0',x"0268CAB1",x"0014CAFE","0011"),
    ('0','0',x"0268CAB1",x"0014CAFE","0011"),
    
    ('1','1',x"FBCC00CC",x"008865FB","0111"),
    ('0','1',x"FBCC00CC",x"008865FB","0111"),
    ('0','1',x"FBCC00CC",x"008865FB","0111"),
    ('0','1',x"FBCC00CC",x"008865FB","0111"),
    ('0','1',x"FBCC00CC",x"008865FB","0111"),
    
    ('1','0',x"FBCC00CC",x"008865FB","0111"),
    ('0','0',x"FBCC00CC",x"008865FB","0111"),
    ('0','0',x"FBCC00CC",x"008865FB","0111"),
    ('0','0',x"FBCC00CC",x"008865FB","0111"),
    ('0','0',x"FBCC00CC",x"008865FB","0111")
);


end package dependencies_implementation;
