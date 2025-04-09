LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY D_BASCULE IS
    PORT (
        D, CLK, PR, CLR : IN std_logic;
        Q, Q_bar : OUT std_logic
    );
END D_BASCULE;

ARCHITECTURE behavioral OF D_BASCULE IS
    COMPONENT JK
        PORT (
            J, K, CLK, PR, CLR : IN std_logic;
            Q, Q_bar : OUT std_logic
        );
    END COMPONENT;

    SIGNAL J, K : std_logic;
BEGIN

    J <= D;
    K <= NOT D;

    U1: JK PORT MAP (J, K, CLK, PR, CLR, Q, Q_bar);
END behavioral;

