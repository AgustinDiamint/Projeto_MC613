library ieee; 
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


entity create_piece is 
port (
  clock         : in  std_logic;
  sync_reset    : in  std_logic;
  en            : in  std_logic;
  piece         : out std_logic_vector(2 downto 0 ));
end create_piece;

architecture rtl of create_piece is  
signal r_lfsr : std_logic_vector (3 downto 1);
signal aux : std_logic_vector(2 downto 0);
    begin  
    process (clock) begin 
        if rising_edge(clock) then 
            if(sync_reset='1') then
                r_lfsr   <= "101";
            elsif (en = '1') then 
                r_lfsr(3) <= r_lfsr(2) xor r_lfsr(1);
                r_lfsr(2) <= r_lfsr(3);
                r_lfsr(1) <= r_lfsr(2);   
      
            end if; 
        end if; 
    end process; 
    
   aux <= "001" when  r_lfsr = "000" else r_lfsr;
   piece <= aux when en = '1';
   
end architecture rtl;
