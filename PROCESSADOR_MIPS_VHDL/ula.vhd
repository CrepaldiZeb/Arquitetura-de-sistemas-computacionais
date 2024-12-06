library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity ula is
  port (
    a      : in    std_logic_vector(31 downto 0);
    b      : in    std_logic_vector(31 downto 0);
    aluctl : in    std_logic_vector(3 downto 0);

    r        : out   std_logic_vector(31 downto 0);
    zero     : out   std_logic;
    overflow : out   std_logic;
    cout     : out   std_logic
  );
end entity ula;

architecture rtl of ula is

  signal result : std_logic_vector(32 downto 0);

  signal a_aux : std_logic_vector(32 downto 0);
  signal b_aux : std_logic_vector(32 downto 0);

  signal stl : std_logic;

begin

  -- Concatena para as entradas ficarem com 33 bits e tornar possível outras operações.
  a_aux <= '0' & a;
  b_aux <= '0' & b;

  with ALUCtl select result <=
    a_aux and b_aux when "0000",
    a_aux or b_aux when "0001",
    std_logic_vector(signed(a_aux) + signed(b_aux)) when "0010",
    std_logic_vector(signed(a_aux) - signed(b_aux)) when "0110",
    NOT (a_aux or b_aux) when "1100",
    (others => '0') when others;

  stl <= '1' when aluctl = "0111" and (signed(b_aux) > signed(a_aux)) else
         '0';

  with stl select r <=
    (others => '1') when '1',
    result(31 downto 0) when others;

  overflow <= (a(31) and b(31) and NOT result(31)) or
              (NOT a(31) and NOT b(31) and result(31));

  zero <= '1' when result = x"00000000" else
          '0';
  cout <= result(32) when aluctl = "0010" else
          (NOT result(32)) when aluctl = "0110" else
          '0';

end architecture rtl;
