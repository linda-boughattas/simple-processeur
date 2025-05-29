library ieee;
use ieee.std_logic_1164.all;

entity tb_machine_etat is
end entity;

architecture behavior of tb_machine_etat is

    -- Component Declaration
    component machine_etat
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
    end component;

    signal clk     : std_logic := '0';
    signal reset   : std_logic := '1';
    signal opcode  : std_logic_vector(3 downto 0) := (others => '0');
    signal accZ    : std_logic := '0';
    signal acc15   : std_logic := '0';

    signal RnW     : std_logic;
    signal selA    : std_logic;
    signal selB    : std_logic;
    signal pc_ld   : std_logic;
    signal ir_ld   : std_logic;
    signal acc_ld  : std_logic;
    signal acc_oe  : std_logic;
    signal alufs   : std_logic_vector(3 downto 0);

begin

    uut: machine_etat
        port map (
            clk     => clk,
            reset   => reset,
            opcode  => opcode,
            accZ    => accZ,
            acc15   => acc15,
            RnW     => RnW,
            selA    => selA,
            selB    => selB,
            pc_ld   => pc_ld,
            ir_ld   => ir_ld,
            acc_ld  => acc_ld,
            acc_oe  => acc_oe,
            alufs   => alufs
        );

    clk_process : process
    begin
        while now < 200 ns loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    -- Stimulus Process
    stim_proc: process
    begin
        wait for 10 ns;
        reset <= '0';
        wait for 10 ns;
        
        opcode <= "0000"; 
        wait for 20 ns;

        opcode <= "0010";
        wait for 20 ns;

        opcode <= "0001"; 
        wait for 20 ns;

        opcode <= "0111";
        wait for 20 ns;

        wait;
    end process;

end architecture;

