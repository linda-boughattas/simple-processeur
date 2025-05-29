library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
	port (
		alufs	: in  std_logic_vector(3 downto 0);
		A 	: in  std_logic_vector(15 downto 0);
		B	: in  std_logic_vector(15 downto 0);
		S	: out std_logic_vector(15 downto 0)
	);
end entity alu;

architecture behavior of alu is
	signal A_us		: unsigned(15 downto 0);
	signal B_us		: unsigned(15 downto 0);
	signal result	: unsigned(15 downto 0);

begin
	-- Conversion pour faire les operations arithmetiques
	A_us <= unsigned(A);
	B_us <= unsigned(B);

	process(alufs, A_us, B_us)
	begin
		case alufs is
			when "0000" => -- S = B
				result <= B_us;
			when "0001" => -- S = A - B
				result <= A_us - B_us;
			when "0010" => -- S = A + B
				result <= A_us + B_us;
			when "0011" => -- S = B + 1
				result <= B_us + 1;
			when others =>
				result <= (others => '0');
		end case;
	end process;

	S <= std_logic_vector(result);

end architecture behavior;

