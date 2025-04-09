LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MUX4_TO_1 IS
    PORT (
        S0, S1 : IN std_logic;
        T0, T1, T2, T3 : IN std_logic;
        Y : OUT std_logic   -- Sortie
    );
END MUX4_TO_1;

ARCHITECTURE behavioral OF MUX4_TO_1 IS
BEGIN
    PROCESS (S0, S1, T0, T1, T2, T3)
    BEGIN
        CASE (S1 & S0) IS
            WHEN "00" => Y <= T0;
            WHEN "01" => Y <= T1;
            WHEN "10" => Y <= T2;
            WHEN "11" => Y <= T3;
            WHEN OTHERS => Y <= '0';
        END CASE;
    END PROCESS;
END behavioral;

