library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity ula_tb is
end entity ula_tb;

architecture bench of ula_tb is

  -- Período do clock
  constant clk_period : time := 10 ps;
  -- Generics
  -- Ports
  signal a        : std_logic_vector(31 downto 0);
  signal b        : std_logic_vector(31 downto 0);
  signal aluctl   : std_logic_vector(3 downto 0);
  signal r        : std_logic_vector(31 downto 0);
  signal zero     : std_logic;
  signal overflow : std_logic;
  signal cout     : std_logic;

begin

  ula_inst : entity work.ULA
    port map (
      a        => a,
      b        => b,
      aluctl   => aluctl,
      r        => r,
      zero     => zero,
      overflow => overflow,
      cout     => cout
    );

-- clk <= not clk after clk_period/2;
	
	stimulus_proc: process
    begin
        -- Teste para operação AND
        a <= "00000000000000000000000000000001";
        b <= "00000000000000000000000000000010";
        aluctl <= "0000";
        wait for 10 ps;
        
        -- Teste para operação OR
        aluctl <= "0001";
        wait for 10 ps;

        -- Teste para operação de soma
        a <= "00000000000000000000000000000010";
        b <= "00000000000000000000000000000010";
        aluctl <= "0010";
        wait for 10 ps;
        
        -- Teste para operação de subtração
        a <= "00000000000000000000000000000100";
        b <= "00000000000000000000000000000010";
        aluctl <= "0110";
        wait for 10 ps;

        -- Teste para operação NOT (NAND)
        aluctl <= "1100";
        wait for 10 ps;
		wait;
    end process;
	
	
end architecture bench;