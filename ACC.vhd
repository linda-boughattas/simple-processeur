library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity acc is
    port (
        acc_ld   : in  std_logic;
        acc_in  : in  std_logic_vector(15 downto 0);
        acc_out  : out std_logic_vector(15 downto 0);
        accZ     : out std_logic;
        acc15    : out std_logic
    );
end entity;

architecture rtl of acc is
    signal acc_reg : std_logic_vector(15 downto 0) := (others => '0');
begin
    process(acc_ld, acc_in)
    begin
        if acc_ld = '1' then
            acc_reg <= acc_in;
        end if;
    end process;

    acc_out <= acc_reg;

    accZ  <= '1' when acc_reg = x"0000" else '0';
    acc15 <= acc_reg(15);

end architecture;

