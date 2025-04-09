library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Memory is
    Port (
        address    : in  STD_LOGIC_VECTOR(11 downto 0);
        RnW        : in  STD_LOGIC;
        instruction: inout STD_LOGIC_VECTOR(15 downto 0)
    );
end Memory;

architecture Behavioral of Memory is
    type ROM_Array is array (0 to 7) of STD_LOGIC_VECTOR(15 downto 0);
    signal ROM : ROM_Array := (
        X"0100", -- LDA @100h
        X"2101", -- ADD @101h
        X"6005", -- JNE 005h
        X"3100", -- SUB @100h
        X"3100", -- SUB @100h
        X"2100", -- ADD @100h
        X"7000", -- STP
        others => X"0000"
    );

    signal instruction_reg : STD_LOGIC_VECTOR(15 downto 0);
begin
    process(RnW, address)
    begin
        if RnW = '1' then
            instruction_reg <= ROM(to_integer(unsigned(address(2 downto 0)))); -- 3-bit address
        else
            instruction_reg <= (others => '0');
        end if;
    end process;

    instruction <= instruction_reg;

end Behavioral;

