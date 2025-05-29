library ieee;
use ieee.std_logic_1164.all;

entity muxA is
	port (
		a	: in  std_logic_vector(11 downto 0);
		b	: in  std_logic_vector(11 downto 0);
		selA	: in  std_logic;
		
		q	: out std_logic_vector(11 downto 0)
	);
end entity muxA;

architecture comb of muxA is
begin
	
	q <= a when selA = '0' else
		 b;

end architecture comb;
