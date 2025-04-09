library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
    port (
        pc_ld   : in  std_logic;
        pc_in   : in  std_logic_vector(15 downto 0);
        pc_out  : out std_logic_vector(11 downto 0)
    );
end entity;

architecture Behavioral of pc is
    signal pc_reg : std_logic_vector(11 downto 0) := (others => '0');
begin
    process(pc_ld, pc_in)
    begin
        if pc_ld = '1' then
            pc_reg <= pc_in(11 downto 0);
        end if;
    end process;

    pc_out <= pc_reg;
end architecture;

