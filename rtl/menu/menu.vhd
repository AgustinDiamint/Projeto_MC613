library ieee; 
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


entity menu is 
port (
	clock		: in 	std_logic;
	key_on 	: in 	std_logic_vector(2 downto 0);
   key_code : in 	std_logic_vector(47 downto 0);
	quit		: out std_logic;
	start		: out std_logic);
end menu;

architecture rtl of menu is
	signal temp: std_logic_vector(15 downto 0);
begin
	process (key_on(0), clock)
	begin
		if (rising_edge(clock)) then
			temp 	<= key_code(15 downto 0);
			if temp = x"0015" then
				quit <= '1';
			elsif temp = x"005a" then
				start <= '1';
			end if;
		end if;
	quit <= '0';
	start <= '0';
	end process;
end architecture rtl;
