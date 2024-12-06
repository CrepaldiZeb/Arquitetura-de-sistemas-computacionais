library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity mux_2_1 is
  port (
    a   : in    std_logic_vector(31 downto 0);
    b   : in    std_logic_vector(31 downto 0);
    sel : in    std_logic;

    output : out   std_logic_vector(31 downto 0)
  );
end entity mux_2_1;

architecture behavior of mux_2_1 is

begin

  with sel select output <=
    a when '0',
    b when others;

end architecture behavior;
