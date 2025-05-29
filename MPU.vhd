library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mpu is
    port (
        clk   : in  std_logic;
        reset : in  std_logic
    );
end entity mpu;

architecture rtl of mpu is

    component machine_etat is
        Port (
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
    component muxA is
        port (
            a    : in  std_logic_vector(11 downto 0);
            b    : in  std_logic_vector(11 downto 0);
            selA : in  std_logic;
            q    : out std_logic_vector(11 downto 0)
        );
    end component;
    component muxB is
        port (
            a    : in  std_logic_vector(11 downto 0);
            b    : in  std_logic_vector(15 downto 0);
            selB : in  std_logic;
            q    : out std_logic_vector(15 downto 0)
        );
    end component;
    component acc is
        port (
            acc_in  : in  std_logic_vector(15 downto 0);
            acc_ld  : in  std_logic;
            acc_out : out std_logic_vector(15 downto 0);
            accZ    : out std_logic;
            acc15   : out std_logic
        );
    end component;
    component alu is
        port (
            alufs : in  std_logic_vector(3 downto 0);
            A     : in  std_logic_vector(15 downto 0);
            B     : in  std_logic_vector(15 downto 0);
            S     : out std_logic_vector(15 downto 0)
        );
    end component;
    component pc is
        port (
            pc_ld  : in  std_logic;
            pc_in  : in  std_logic_vector(15 downto 0);
            pc_out : out std_logic_vector(11 downto 0)
        );
    end component;
    component ir is
        port (
            data_in  : in  std_logic_vector(15 downto 0);
            ir_ld    : in  std_logic;
            data_out : out std_logic_vector(11 downto 0);
            opcode   : out std_logic_vector(3 downto 0)
        );
    end component;
    component Memory is
        port (
            bus_addresse : in  std_logic_vector(11 downto 0);
            RnW          : in  std_logic;
            bus_donnee   : inout std_logic_vector(15 downto 0)
        );
    end component;

    signal opcode  : std_logic_vector(3 downto 0);
    signal accZ    : std_logic;
    signal acc15   : std_logic;
    signal RnW     : std_logic;
    signal selA    : std_logic;
    signal selB    : std_logic;
    signal pc_ld   : std_logic;
    signal ir_ld   : std_logic;
    signal acc_ld  : std_logic;
    signal acc_oe  : std_logic;
    signal alufs   : std_logic_vector(3 downto 0);
    signal pc_out      : std_logic_vector(11 downto 0);
    signal ir_out      : std_logic_vector(11 downto 0);
    signal imm12       : std_logic_vector(11 downto 0);
    signal muxA_out    : std_logic_vector(11 downto 0);
    signal muxB_out    : std_logic_vector(15 downto 0);
    signal acc_out     : std_logic_vector(15 downto 0);
    signal alu_out     : std_logic_vector(15 downto 0);
    signal addr_bus    : std_logic_vector(11 downto 0);
    signal data_bus    : std_logic_vector(15 downto 0);
    signal acc_drive   : std_logic_vector(15 downto 0);
begin
    U_muxA: muxA
        port map (
            a    => pc_out,
            b    => ir_out,
            selA => selA,
            q    => muxA_out
        );

    U_pc: pc
        port map (
            pc_ld => pc_ld,
            pc_in => alu_out,
            pc_out=> pc_out
        );

    U_ir: ir
        port map (
            data_in => data_bus,
            ir_ld   => ir_ld,
            data_out=> ir_out,
            opcode  => opcode
        );
    imm12 <= ir_out;

    U_muxB: muxB
        port map (
            a    => imm12,
            b    => acc_out,
            selB => selB,
            q    => muxB_out
        );

    U_acc: acc
        port map (
            acc_in  => data_bus,
            acc_ld  => acc_ld,
            acc_out => acc_out,
            accZ    => accZ,
            acc15   => acc15
        );

    U_alu: alu
        port map (
            alufs => alufs,
            A     => acc_out,
            B     => muxB_out,
            S     => alu_out
        );

    acc_drive <= acc_out when acc_oe = '1' else (others => 'Z');

    data_bus <= acc_drive;

    addr_bus <= muxA_out;

    U_mem: Memory
        port map (
            bus_addresse => addr_bus,
            RnW          => RnW,
            bus_donnee   => data_bus
        );

    U_ctrl: machine_etat
        port map (
            clk    => clk,
            reset  => reset,
            opcode => opcode,
            accZ   => accZ,
            acc15  => acc15,
            RnW    => RnW,
            selA   => selA,
            selB   => selB,
            pc_ld  => pc_ld,
            ir_ld  => ir_ld,
            acc_ld => acc_ld,
            acc_oe => acc_oe,
            alufs  => alufs
        );

end architecture rtl;

