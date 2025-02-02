library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity mono_cpu is
  port (
    clk_main : in    std_logic
  );
end entity mono_cpu;

architecture behavioral of mono_cpu is

  -- CONTROL UNIT SIGNAL
  signal sig_zero       : std_logic;
  signal sig_regdst     : std_logic;
  signal sig_jump       : std_logic;
  signal sig_branch     : std_logic;
  signal sig_memread    : std_logic;
  signal sig_memtoreg   : std_logic;
  signal sig_memwrite   : std_logic;
  signal sig_alusrc     : std_logic;
  signal sig_regwrite   : std_logic;
  signal sig_alucontrol : std_logic_vector(3 downto 0);
  signal sig_aluop      : std_logic_vector(1 downto 0);
  -- PC
  signal pc_addr_data   : std_logic_vector(31 downto 0) := x"00000000";
  signal nextpc_data    : std_logic_vector(31 downto 0) := x"00000000";
  signal branchtarget   : std_logic_vector(31 downto 0) := x"00000000";
  signal jumpaddress    : std_logic_vector(31 downto 0) := x"00000000";
  signal currentaddress : std_logic_vector(31 downto 0) := x"00000000";

  signal readdata1 : std_logic_vector(31 downto 0);
  signal readdata2 : std_logic_vector(31 downto 0);
  signal aluresult : std_logic_vector(31 downto 0);
  signal writedata : std_logic_vector(31 downto 0);

  signal memory_read_data : std_logic_vector(31 downto 0);
  signal regwriteaddress  : std_logic_vector(4 downto 0);
  signal alusrc_data      : std_logic_vector(31 downto 0);
  signal signextend       : std_logic_vector(31 downto 0);
  signal instruction_data : std_logic_vector(31 downto 0);

  signal pc_4_addr_data             : std_logic_vector(31 downto 0);
  signal four                       : std_logic_vector(31 downto 0) := x"00000004";
  signal signextend_shift_left_data : std_logic_vector(31 downto 0);
  signal branch_address_data        : std_logic_vector(31 downto 0) := x"00000000";

  component mux_2_1 is
    port (
      a      : in    std_logic_vector(31 downto 0);
      b      : in    std_logic_vector(31 downto 0);
      sel    : in    std_logic;
      output : out   std_logic_vector(31 downto 0)
    );
  end component;

begin

  sign_extend_inst : entity work.sign_extend
    port map (
      input_data  => instruction_data(15 downto 0),
      output_data => signextend
    );

  reg_dst_mux : entity work.mux_2_1_5_bits
    port map (
      a      => instruction_data(20 downto 16),
      b      => instruction_data(15 downto 11),
      sel    => sig_regdst,
      output => regwriteaddress
    );

  alu_src_mux : component mux_2_1
    port map (
      a      => readdata2,
      b      => signextend,
      sel    => sig_alusrc,
      output => alusrc_data
    );

  alu_control_inst : entity work.alu_control
    port map (
      funct    => instruction_data(5 downto 0),
      alu_op   => sig_aluop,
      alu_ctrl => sig_alucontrol
    );

  ula_inst : entity work.ula
    port map (
      a      => readdata1,
      b      => alusrc_data,
      aluctl => sig_alucontrol,
      r      => aluresult,
      zero   => sig_zero
    );

  data_memory_inst : entity work.data_memory
    port map (
      clk        => clk_main,
      address    => aluresult,
      write_data => readdata2,
      mem_write  => sig_memwrite,
      mem_read   => sig_memread,
      read_data  => memory_read_data
    );

  mem_to_reg_mux : component mux_2_1
    port map (
      a      => aluresult,
      b      => memory_read_data,
      sel    => sig_memtoreg,
      output => writedata
    );

  pc_reg : entity work.single_reg
    port map (
      clk      => clk_main,
      wdata    => nextpc_data,
      data_out => currentaddress
    );

  pc_4_addr_data             <= std_logic_vector(unsigned(currentaddress) + unsigned(four));
  signextend_shift_left_data <= signextend(signextend'high - 2 downto 0) & "00";
  branch_address_data        <= std_logic_vector(unsigned(pc_4_addr_data) + unsigned(signextend_shift_left_data));
  jumpaddress                <= pc_4_addr_data(31 downto 28) & (instruction_data(25 downto 0) & "00");

  branch_mux : component mux_2_1
    port map (
      a      => pc_4_addr_data,
      b      => signextend_shift_left_data,
      sel    => sig_branch and sig_zero,
      output => branchtarget
    );

  jump_mux : component mux_2_1
    port map (
      a      => branchtarget,
      b      => jumpaddress,
      sel    => sig_jump,
      output => nextpc_data
    );

  instruction_memory_inst : entity work.instruction_memory
    port map (
      address     => currentaddress,
      instruction => instruction_data
    );

  reg_bank_inst : entity work.reg_bank
    port map (
      clk     => clk_main,
      reset   => '0',
      rdaddr1 => instruction_data(25 downto 21),
      rdaddr2 => instruction_data(20 downto 16),
      wraddr  => regwriteaddress,
      wdata   => writedata,
      we      => sig_regwrite,
      rddata1 => readdata1,
      rddata2 => readdata2
    );

  control_unit_inst : entity work.control_unit
    port map (
      opcode   => instruction_data(31 downto 26),
      memread  => sig_memread,
      memwrite => sig_memwrite,
      memtoreg => sig_memtoreg,
      aluop    => sig_aluop,
      alusrc   => sig_alusrc,
      regwrite => sig_regwrite,
      regdst   => sig_regdst,
      jump     => sig_jump,
      branch   => sig_branch
    );

end architecture behavioral;
