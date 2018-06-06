library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all ;

entity clock is
port (
    clk : in std_logic;
    decimal : in std_logic_vector(3 downto 0);
    unity : in std_logic_vector(3 downto 0);
    set_hour : in std_logic;
    set_minute : in std_logic;
    set_second : in std_logic;
    hour_dec, hour_un : out std_logic_vector(6 downto 0);
    min_dec, min_un : out std_logic_vector(6 downto 0);
    sec_dec, sec_un : out std_logic_vector(6 downto 0)
);
end clock;
architecture rtl of clock is
    component clk_div is
    port (
        clk : in std_logic;
        clk_hz : out std_logic
        );
    end component;
    
    component bin2hex is
    port (
        SW: in std_logic_vector(3 downto 0);
        HEX0: out std_logic_vector(6 downto 0)
        );
    end component;
    
    
    signal clk_hz : std_logic;
    signal s_dec : std_logic_vector (3 downto 0);
    signal s_un  : std_logic_vector (3 downto 0);
    signal m_dec : std_logic_vector (3 downto 0);
    signal m_un  : std_logic_vector (3 downto 0);
    signal h_dec : std_logic_vector (3 downto 0);
    signal h_un  : std_logic_vector (3 downto 0);
begin
    clock_divider : clk_div port map(clk, clk_hz);
    
    PROCESS (clk)
    BEGIN
    IF (clk'EVENT AND clk = '1') THEN
        IF (set_hour = '1') THEN
            IF decimal = "0010" THEN
                IF unity < "0100" THEN
                    h_dec <= decimal;
                    h_un <= unity;
                END IF;
            ELSIF decimal < "0010" THEN
                IF unity < "1010" THEN
                    h_dec <= decimal;
                    h_un <= unity;
                END IF;
            END IF;
        ELSIF (set_minute = '1') THEN
            IF decimal < "0110" THEN
                IF unity < "1010" THEN
                    m_dec <= decimal;
                    m_un <= unity;
                END IF;
            END IF;
        ELSIF (set_second = '1') THEN
            IF decimal < "0110" THEN
                IF unity < "1010" THEN
                    s_dec <= decimal;
                    s_un <= unity;
                END IF;
            END IF;
        ELSIF (clk_hz = '1') THEN
            IF (s_un) = "1001" THEN
                s_un <= "0000";
                IF (s_dec) = "0101" THEN
                        s_dec <= "0000";
                        IF (m_un) = "1001" THEN
                            m_un <= "0000";
                            IF (m_dec) = "0101" THEN
                                m_dec <= "0000";
                                IF (h_un) = "1001" THEN
                                        h_un <= "0000";
                                        IF (h_dec) = "0010" THEN
                                            h_dec <= "0000";
                                        ELSE
                                            h_dec <= h_dec + 1;
                                        END IF;
                                ELSE
                                        h_un <= h_un + 1;
                                END IF;
                            ELSE
                                m_dec <= m_dec + 1;
                            END IF;
                        ELSE
                            m_un <= m_un + 1;
                        END IF;
                    ELSE
                        s_dec <= s_dec + 1;
                    END IF;
            ELSE
                s_un <= s_un + 1;
            END IF;
        END IF;
    END IF;
    END PROCESS;
    
    hex_sec1: bin2hex PORT MAP (s_un, sec_un);
    hex_sec2: bin2hex PORT MAP (s_dec, sec_dec);
    hex_min1: bin2hex PORT MAP (m_un, min_un);
    hex_min2: bin2hex PORT MAP (m_dec, min_dec);
    hex_hour1: bin2hex PORT MAP (h_un, hour_un);
    hex_hour2: bin2hex PORT MAP (h_dec, hour_dec);
end rtl;
