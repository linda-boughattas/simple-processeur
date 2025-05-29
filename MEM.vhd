library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Memory is
    Port (
        bus_addresse : in STD_LOGIC_VECTOR(11 downto 0);
        RnW          : in STD_LOGIC;
        bus_donnee   : inout STD_LOGIC_VECTOR(15 downto 0)
    );
end Memory;

architecture Behavioral of Memory is
    type Mem_Array is array (0 to 4095) of STD_LOGIC_VECTOR(15 downto 0);

    signal RAM : Mem_Array := (
        0 => X"0100", -- LDA @100h
        1 => X"2101", -- ADD @101h
        2 => X"6005", -- JNE 005h
        3 => X"3100", -- SUB @100h
        4 => X"3100", -- SUB @100h
        5 => X"2100", -- ADD @100h
        6 => X"7000", -- STP
        others => X"0000"
    );

begin
    -- Memory read
    bus_donnee <= RAM(to_integer(unsigned(bus_addresse))) when RnW = '1' else (others => 'Z');

    -- Memory write
    WRITE_PROC: for i in 0 to 4095 generate
        RAM(i) <= bus_donnee when RnW = '0' and to_integer(unsigned(bus_addresse)) = i else RAM(i);
    end generate;

end Behavioral;

