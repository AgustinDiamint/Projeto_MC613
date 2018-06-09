library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


entity mov_piece is
port (
	clock		: in 	std_logic;
	key_on 	: in 	std_logic_vector(2 downto 0);
   key_code : in 	std_logic_vector(47 downto 0);
	direction: out std_logic_vector(1 downto 0);
	mov 		: out std_logic;
	rotation	: out std_logic);
end mov_piece;

architecture rtl of mov_piece is
	signal temp: std_logic_vector(15 downto 0);
begin
	process (key_on(0), clock)
	begin
		if (rising_edge(clock)) then
			--LEFT
			if key_code(15 downto 0) = x"e06b" then
				direction <= "11";
				mov <= '1';
			--RIGHT
			elsif key_code(15 downto 0) = x"e074" then
				direction <= "01";
				mov <= '1';
			--DOWN
			elsif key_code(15 downto 0) = x"e072" then
				direction <= "10";
				mov <= '1';
			--UP -> ROTATE
			elsif key_code(15 downto 0) = x"e075" then
				rotation <= '1';
			end if;
		end if;
	mov <= '0';
	end process;
end architecture rtl;
