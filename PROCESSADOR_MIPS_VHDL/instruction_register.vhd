library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity instruction_register is
  port (
    instruction_data  : in    std_logic_vector(31 downto 0);
    ir_write          : in    std_logic;
    clk               : in    std_logic;
    instruction_31_26 : out   std_logic_vector(5 downto 0);
    instruction_25_21 : out   std_logic_vector(4 downto 0);
    instruction_20_16 : out   std_logic_vector(4 downto 0);
    instruction_15_0  : out   std_logic_vector(15 downto 0)
  );
end entity instruction_register;

architecture rtl of instruction_register is

  signal instruction_reg : std_logic_vector(31 downto 0);

begin

  process (clk) is
  begin

    if rising_edge(clk) then
      if (ir_write = '1') then
        instruction_reg <= instruction_data;
      end if;
    end if;

  end process;

  instruction_31_26 <= instruction_reg(31 downto 26);
  instruction_25_21 <= instruction_reg(25 downto 21);
  instruction_20_16 <= instruction_reg(20 downto 16);
  instruction_15_0  <= instruction_reg(15 downto 0);

end architecture rtl;
