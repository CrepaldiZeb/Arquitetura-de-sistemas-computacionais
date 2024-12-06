library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity RegBank is
  port (
    clk     : in    std_logic;
    reset   : in    std_logic;
    rdAddr1 : in    std_logic_vector(4 downto 0);
    rdAddr2 : in    std_logic_vector(4 downto 0);
    wrAddr  : in    std_logic_vector(4 downto 0);
    wData   : in    std_logic_vector(31 downto 0);
    we      : in    std_logic;

    rdData1 : out   std_logic_vector(31 downto 0);
    rdData2 : out   std_logic_vector(31 downto 0)
  );
end entity RegBank;

architecture rtl of RegBank is

  type regs_array is array(0 to 31) of std_logic_vector(31 downto 0);

  signal regs : regs_array;

begin
	
  rdData1 <= regs(to_integer(unsigned(rdAddr1)));
  rdData2 <= regs(to_integer(unsigned(rdAddr2)));
	
	process(clk) is
	begin 
		if rising_edge(clk) then
			if reset = '1' then
				for i in 0 to 31 loop
					regs(i) <= (others =>'0');
				end loop;
			end if;
			if we = '1' then
				regs(to_integer(unsigned(wrAddr))) <= wData;
			end if;
		end if;
	end process;
	
end architecture rtl;
