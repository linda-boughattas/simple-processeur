library ieee;
use ieee.std_logic_1164.all;

entity muxB is
	port (
		a	: in  std_logic_vector(11 downto 0);
		b	: in  std_logic_vector(15 downto 0);
		selB	: in  std_logic;
		
		q	: out std_logic_vector(15 downto 0)
	);
end entity muxB;

architecture comb of muxB is
begin
	
	q <= a when selB = '0' else
		 b;

end architecture comb;
