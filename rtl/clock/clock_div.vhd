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
	SIGNAL count    : integer;
   SIGNAL count2   : integer;
	SIGNAL temp     : std_logic;
	SIGNAL temp2    : std_logic;
begin
	Process (clock)
	begin
		IF (clock'EVENT and clock = '1') THEN
		    IF count = 0 THEN
				temp <= '1';
				count <= 25000000;
			ELSE
				temp <= '0';
				count <= count - 1;
			END IF;
			
			IF count2 = 0 THEN
				temp2 <= '1';
				count2 <= 12500000;
			ELSE
				temp2 <= '0';
				count2 <= count2 - 1;
			END IF;
		END IF;
	END Process;
	clock_hz <= temp;
	clock_half <= temp2;
end behavioral;
