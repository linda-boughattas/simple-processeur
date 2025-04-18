LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY T_CASCADE IS
    GENERIC (NUM_BITS : INTEGER := 4);
    PORT (
        T : IN std_logic;
        H, PR, CLR : IN std_logic;
        S0, S1 : IN std_logic;
        Q : OUT std_logic;
        Q_bar : OUT std_logic
    );
END T_CASCADE;

ARCHITECTURE behavioral OF T_CASCADE IS
    COMPONENT T_BASCULE
        PORT (
            T, H, PR, CLR : IN std_logic;
            Q, Q_bar : OUT std_logic
        );
    END COMPONENT;
    
    COMPONENT MUX4_TO_1
        PORT (
            S0, S1 : IN std_logic;
            T0, T1, T2, T3 : IN std_logic;
            Y : OUT std_logic
        );
    END COMPONENT;

    SIGNAL Qs : std_logic_vector(3 DOWNTO 0);
BEGIN

    U1: T_BASCULE PORT MAP (T, H, PR, CLR, Qs(0), Q_bar);
    U2: T_BASCULE PORT MAP (T, Qs(0), PR, CLR, Qs(1), Q_bar);
    U3: T_BASCULE PORT MAP (T, Qs(1), PR, CLR, Qs(2), Q_bar);
    U4: T_BASCULE PORT MAP (T, Qs(2), PR, CLR, Qs(3), Q_bar);

    MUX: MUX4_TO_1 PORT MAP (S0, S1, Qs(0), Qs(1), Qs(2), Qs(3), Q);

END behavioral;

