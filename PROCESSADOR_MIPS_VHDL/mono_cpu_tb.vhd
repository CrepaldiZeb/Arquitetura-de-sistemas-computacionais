library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity mono_cpu_tb is
-- Testbench entities do not have ports
end entity mono_cpu_tb;

architecture behavior of mono_cpu_tb is

  -- Sinal para simular o relógio
  signal clk_main : std_logic := '0';

  -- Componente que representa a CPU Monociclo MIPS
  component mono_cpu is
    port (
      clk_main : in    std_logic
    );
  end component;

  -- Frequência do relógio em hertz (Exemplo: 100 MHz)
  constant clk_period : time := 10 ns;

begin

  -- Instância da CPU Monociclo MIPS
  uut : component mono_cpu
    port map (
      clk_main => clk_main
    );

  -- Processo para gerar o relógio
  clk_process : process is
  begin

    while true loop

      clk_main <= '0';
      wait for clk_period / 2;  -- Espera metade do período
      clk_main <= '1';
      wait for clk_period / 2;  -- Espera a outra metade

    end loop;

  end process clk_process;

  -- Processo para inicializar e testar o comportamento da CPU
  stim_proc : process is
  begin

    wait until rising_edge(clk_main);

    wait for clk_period;
    wait for 10000 ns;
    assert false
      report "Simulação concluída"
      severity failure;

  end process stim_proc;

end architecture behavior;
