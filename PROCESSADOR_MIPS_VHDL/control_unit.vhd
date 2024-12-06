library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity control_unit is
  port (
    opcode   : in    std_logic_vector(5 downto 0);
    memread  : out   std_logic;
    memwrite : out   std_logic;
    memtoreg : out   std_logic;
    aluop    : out   std_logic_vector(1 downto 0);
    alusrc   : out   std_logic;
    regwrite : out   std_logic;
    regdst   : out   std_logic;
    jump     : out   std_logic;
    branch   : out   std_logic
  );
end entity control_unit;

architecture behavioral of control_unit is

begin

  process (opcode) is
  begin

    memread  <= '0';
    memwrite <= '0';
    memtoreg <= '0';
    aluop    <= "00";
    alusrc   <= '0';
    regwrite <= '0';
    regdst   <= '0';
    jump     <= '0';
    branch   <= '0';

    case opcode is

      -- R-Type
      when "000000" =>

        aluop    <= "10";
        regwrite <= '1';
        regdst   <= '1';

      -- SW
      when "101011" =>

        memwrite <= '1';
        alusrc   <= '1';

      -- LW
      when "100011" =>

        memread  <= '1';
        memtoreg <= '1';
        alusrc   <= '1';
        regwrite <= '1';

      -- BEQ
      when "000100" =>

        aluop  <= "01";
        branch <= '1';

      -- J
      when "000010" =>

        jump <= '1';

      -- ADDI
      when "001000" =>

        aluop    <= "00";
        alusrc   <= '1';
        regwrite <= '1';
        regdst   <= '0';

      when others =>

    -- Tratamento para outros casos ou opcionalmente deixe vazio

    end case;

  end process;

end architecture behavioral;
