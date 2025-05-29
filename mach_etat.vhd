library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity machine_etat is
    port (
        clk     : in std_logic;
        reset   : in std_logic;
        opcode  : in std_logic_vector(3 downto 0);
        accZ    : in std_logic;
        acc15   : in std_logic;

        RnW     : out std_logic;
        selA    : out std_logic;
        selB    : out std_logic;
        pc_ld   : out std_logic;
        ir_ld   : out std_logic;
        acc_ld  : out std_logic;
        acc_oe  : out std_logic;
        alufs   : out std_logic_vector(3 downto 0)
    );
end entity;

architecture dataflow of machine_etat is

    type state_type is (FETCH, DECODE, EXECUTE, LDA, STO, ADD, SUB, JMP, JGE, JNE, STP);
    signal current_state, next_state : state_type;

begin

    -- 1. Registre d?état
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                current_state <= FETCH;
            else
                current_state <= next_state;
            end if;
        end if;
    end process;

    -- Transition détat
    next_state <= DECODE when current_state = FETCH else
              EXECUTE when current_state = DECODE else
              LDA when current_state = EXECUTE and opcode = "0000" else
              STO when current_state = EXECUTE and opcode = "0001" else
              ADD when current_state = EXECUTE and opcode = "0010" else
              SUB when current_state = EXECUTE and opcode = "0011" else
              JMP when current_state = FETCH and opcode = "0100" else
              JGE when current_state = EXECUTE and opcode = "0101" and acc15 = '1' else
              FETCH when current_state = EXECUTE and opcode = "0101" and acc15 = '0' else
              JNE when current_state = EXECUTE and opcode = "0110" and accZ = '1' else
              FETCH when current_state = EXECUTE and opcode = "0110" and accZ = '0' else
              STP when current_state = EXECUTE and opcode = "0111" else
              FETCH when current_state = JGE or current_state = JNE or current_state = LDA or
                           current_state = STO or current_state = ADD or current_state = SUB or
                           current_state = JMP or current_state = STP else
              FETCH;

    -- Assignations des sorties
    RnW    <= '0' when current_state = STO else '1';
    selA <= '0' when current_state = FETCH or current_state = DECODE or current_state = EXECUTE else '1';
    selB <= '1' when current_state = LDA or current_state = ADD or current_state = SUB or current_state = EXECUTE else '0';
    pc_ld  <= '1' when current_state = DECODE
                   or current_state = JMP
                   or (current_state = JGE and acc15 = '0')
                   or (current_state = JNE and accZ  = '0')
               else '0';
    ir_ld  <= '1' when current_state = FETCH else '0';
    acc_ld <= '1' when current_state = LDA or current_state = ADD or current_state = SUB else '0';
    acc_oe <= '1' when current_state = STO else '0';

    alufs  <= "0011" when current_state = DECODE else
              "0010" when current_state = ADD    else
              "0001" when current_state = SUB    else
              "0000";
             

end architecture;

architecture seq of machine_etat is

    type state_type is (FETCH, DECODE, Execute, MEM_ACCESS, WRITEBACK, STP);
    signal state : state_type;

begin

    process(clk, reset)
    begin
        if reset = '1' then
            state <= FETCH;

            -- valeurs de sorties par défaut
            RnW     <= '1';
            selA    <= '0';
            selB    <= '0';
            pc_ld   <= '0';
            ir_ld   <= '0';
            acc_ld  <= '0';
            acc_oe  <= '0';
            alufs   <= "0000";

        elsif rising_edge(clk) then

            -- valeurs de sorties par défaut à chaque cycle
            RnW     <= '1';
            selA    <= '0';
            selB    <= '0';
            pc_ld   <= '0';
            ir_ld   <= '0';
            acc_ld  <= '0';
            acc_oe  <= '0';
            alufs   <= "0000";

            case state is

                when FETCH =>
                    selA    <= '0';
                    RnW     <= '1';
                    ir_ld   <= '1';
                    state   <= DECODE;

                when DECODE =>
                    selB    <= '0';
                    alufs   <= "0011"; -- B+1
                    pc_ld   <= '1';
                    state   <= Execute;

                when Execute =>
                    case opcode is
                        -- LDA addr
                        when "0000" =>
                            selA    <= '1';
                            RnW     <= '1';
                            selB    <= '1';
                            acc_ld  <= '1';
                            alufs   <= "0000"; -- B
                            state   <= FETCH;

                        -- STO addr
                        when "0001" =>
                            selA    <= '1';
                            RnW     <= '0';
                            acc_oe  <= '1';
                            state   <= FETCH;

                        -- ADD addr
                        when "0010" =>
                            selA    <= '1';
                            RnW     <= '1';
                            selB    <= '1';
                            alufs   <= "0010"; -- A+B
                            acc_ld  <= '1';
                            state   <= FETCH;

                        -- SUB addr
                        when "0011" =>
                            selA    <= '1';
                            RnW     <= '1';
                            selB    <= '1';
                            alufs   <= "0001"; -- A-B
                            acc_ld  <= '1';
                            state   <= FETCH;

                        -- JMP addr
                        when "0100" =>
                            selA    <= '1';
                            selB    <= '0';
                            alufs   <= "0000"; -- B
                            pc_ld   <= '1';
                            state   <= FETCH;

                        -- JGE addr
                        when "0101" =>
                            if acc15 = '0' then
                                selA    <= '1';
                                selB    <= '0';
                                alufs   <= "0000"; -- B
                                pc_ld   <= '1';
                            end if;
                            state <= FETCH;

                        -- JNE addr
                        when "0110" =>
                            if accZ = '0' then
                                selA    <= '1';
                                selB    <= '0';
                                alufs   <= "0000"; -- B
                                pc_ld   <= '1';
                            end if;
                            state <= FETCH;

                        -- STOP
                        when "0111" =>
                            state <= STP;

                        -- default
                        when others =>
                            state <= FETCH;

                    end case;

                when MEM_ACCESS =>
                    RnW     <= '0';
                    state   <= WRITEBACK;

                when WRITEBACK =>
                    pc_ld   <= '1';
                    state   <= FETCH;

                when STP =>
                    -- état d'arrêt, pas de transition
                    state <= STP;

            end case;
        end if;
    end process;

end architecture;
