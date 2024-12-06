library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity single_reg is
  port (
    clk      : in    std_logic;
    wdata    : in    std_logic_vector(31 downto 0);
    data_out : out   std_logic_vector(31 downto 0)
  );
end entity single_reg;

architecture rtl of single_reg is

  signal reg : std_logic_vector(31 downto 0) := x"00000000";

begin

  data_out <= reg;

  process (clk) is
  begin

    if (rising_edge(clk)) then
      reg <= wdata;
    end if;

  end process;

end architecture rtl;
