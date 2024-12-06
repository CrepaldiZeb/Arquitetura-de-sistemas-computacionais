library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity alu_control is
  port (
    funct    : in    std_logic_vector(5 downto 0);
    alu_op   : in    std_logic_vector(1 downto 0);
    alu_ctrl : out   std_logic_vector(3 downto 0)
  );
end entity alu_control;

architecture rtl of alu_control is

  constant func_add : std_logic_vector(5 downto 0) := "100000";
  constant func_sub : std_logic_vector(5 downto 0) := "100010";
  constant func_and : std_logic_vector(5 downto 0) := "100100";
  constant func_or  : std_logic_vector(5 downto 0) := "100101";
  constant func_slt : std_logic_vector(5 downto 0) := "101010";

begin

  -- ADD
  alu_ctrl <= "0010" when alu_op = "00" else
              --  SUB
              "0110" when alu_op = "01" else
              --  Type-R
              "0010" when alu_op = "10" and funct = func_add else
              "0110" when alu_op = "10" and funct = func_sub else
              "0000" when alu_op = "10" and funct = func_and else
              "0001" when alu_op = "10" and funct = func_or else
              "0111" when alu_op = "10" and funct = func_slt;

end architecture rtl;
