library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ir is
    Port (
        data_in  : in  STD_LOGIC_VECTOR(15 downto 0);
        ir_ld    : in  STD_LOGIC;
        data_out : out STD_LOGIC_VECTOR(11 downto 0);
        opcode   : out STD_LOGIC_VECTOR(3 downto 0)
    );
end ir;

architecture IR of ir is
begin

    data_out <= data_in(11 downto 0) when ir_ld = '1' else (others => '0');
    opcode   <= data_in(15 downto 12) when ir_ld = '1' else (others => '0');

end IR;

