LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; -- Optional, in case of unsigned vector conversion

-- QST:1 comportemental de la bascule JK
ENTITY JK IS
    PORT (
        J, K, H, PR, CLR : IN std_logic;
        Q, Q_bar : OUT std_logic
    );
END JK;

ARCHITECTURE behavioral OF JK IS
    SIGNAL Q_int : std_logic := '0';
BEGIN
    PROCESS (J, K, H, PR, CLR)
    BEGIN
        IF (CLR = '0') THEN
            Q_int <= '0';  -- Reset state to 0
        ELSIF (PR = '0') THEN
            Q_int <= '1';  -- Set state to 1
        ELSIF (H = '1') THEN
            CASE (J & K) IS
                WHEN "00" =>
                    -- No change in state
                    NULL;  
                WHEN "01" =>
                    -- Reset (Q = 0)
                    Q_int <= '0';
                WHEN "10" =>
                    -- Set (Q = 1)
                    Q_int <= '1';
                WHEN "11" =>
                    -- Toggle (invert current state)
                    Q_int <= NOT Q_int;
                WHEN OTHERS =>
                    NULL;
            END CASE;
        END IF;
    END PROCESS;
    
    Q <= Q_int;
    Q_bar <= NOT Q_int;
END behavioral;

-- QST:2 structurel de la bascule JK
ARCHITECTURE structural OF JK IS
    COMPONENT NAND3
        PORT (A, B, C: IN std_logic; Y: OUT std_logic);
    END COMPONENT;
    
    SIGNAL N1, N2, N3, N4 : std_logic;
BEGIN
    -- Implement JK Flip-Flop using NAND gates
    U1: NAND3 PORT MAP (J, H, Q_bar, N1);
    U2: NAND3 PORT MAP (PR, N1, Q_bar, N2);
    U3: NAND3 PORT MAP (Q, H, K, N3);
    U4: NAND3 PORT MAP (Q, N3, CLR, N4);
    Q <= N2;    -- Output Q
    Q_bar <= N4; -- Output Q_bar
END structural;

-- QST:3 pour faire une Bascule T avec JK on fait J=K=1

