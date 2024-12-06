library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity data_memory is
  port (
    clk        : in    std_logic;
    address    : in    std_logic_vector(31 downto 0);
    write_data : in    std_logic_vector(31 downto 0);
    mem_write  : in    std_logic;
    mem_read   : in    std_logic;
    read_data  : out   std_logic_vector(31 downto 0)
  );
end entity data_memory;

architecture behavioral of data_memory is

  type memory_array is array (0 to 255) of std_logic_vector(31 downto 0);

  signal memory : memory_array := (others => (others => '0'));

begin

  process (clk) is
  begin

    if rising_edge(clk) then
      if (mem_write = '1') then
        memory(to_integer(unsigned(address(7 downto 0)))) <= write_data;
      end if;
    end if;

  end process;

  read_data <= memory(to_integer(unsigned(address(7 downto 0)))) when mem_read = '1' else
               (others => '0');

end architecture behavioral;
