library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity reg_bank is
  port (
    clk     : in    std_logic;
    reset   : in    std_logic;
    rdaddr1 : in    std_logic_vector(4 downto 0);
    rdaddr2 : in    std_logic_vector(4 downto 0);
    wraddr  : in    std_logic_vector(4 downto 0);
    wdata   : in    std_logic_vector(31 downto 0);
    we      : in    std_logic;

    rddata1 : out   std_logic_vector(31 downto 0);
    rddata2 : out   std_logic_vector(31 downto 0)
  );
end entity reg_bank;

architecture rtl of reg_bank is

  type regs_array is array(0 to 31) of std_logic_vector(31 downto 0);

  signal regs     : regs_array;
  signal zero_reg : std_logic_vector(31 downto 0) := (others => '0');

begin

  rddata1 <= zero_reg when rdaddr1 = "00000" else
             regs(to_integer(unsigned(rdaddr1)));

  rddata2 <= zero_reg when rdaddr2 = "00000" else
             regs(to_integer(unsigned(rdaddr2)));

  process (clk) is
  begin

    if rising_edge(clk) then
      if (reset = '1') then

        for i in 0 to 31 loop

          regs(i) <= (others => '0');

        end loop;

      end if;
      regs(29) <= x"0000007C";
      if (we = '1' and wraddr /= "00000") then
        regs(to_integer(unsigned(wraddr))) <= wdata;
      end if;
    end if;

  end process;

end architecture rtl;
