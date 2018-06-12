library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all ;

entity clock_div is
  port (
    clock : in std_logic;
    clock_hz : out std_logic;
    clock_half : out std_logic
  );
end clock_div;

architecture behavioral of clock_div is
	SIGNAL Count : STD_LOGIC_VECTOR (27 DOWNTO 0) ;
	SIGNAL temp : STD_LOGIC;
begin
	Process (clock)
	begin
		IF (clock'EVENT and clock = '1') THEN 
			IF count = x"0000000" THEN
				temp <= '1';
				count <= x"2FAF080"; --"25000000"
			ELSE
				temp <= '0';
				count <= count - 1;
			END IF;
		END IF;
	END Process;
	clock_hz <= temp;
    clock_half <= temp;
end behavioral;
