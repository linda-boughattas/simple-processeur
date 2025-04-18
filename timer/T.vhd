LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY T_BASCULE IS
    PORT (
        T, H, PR, CLR : IN std_logic;
        Q, Q_bar : OUT std_logic
    );
END T_BASCULE;

ARCHITECTURE behavioral_T OF T_BASCULE IS
    COMPONENT JK
        PORT (
            J, K, H, PR, CLR : IN std_logic;
            Q, Q_bar : OUT std_logic
        );
    END COMPONENT;

    SIGNAL J, K : std_logic;
BEGIN
    J <= T;
    K <= T;

    U1: JK PORT MAP (J, K, H, PR, CLR, Q, Q_bar);

END behavioral_T;

