library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regbank_board is
    port (
        LEDR: out std_logic_vector(17 downto 0);
		  LEDG: out std_logic_vector(3 downto 0);
		  HEX7: out std_logic_vector(0 to 6);
		  HEX6: out std_logic_vector(0 to 6);
		  HEX5: out std_logic_vector(0 to 6);
		  HEX4: out std_logic_vector(0 to 6);
        SW: in std_logic_vector(17 downto 0);
        KEY: in std_logic_vector(3 downto 0)
    );
end entity regbank_board;

architecture bhv of regbank_board is

    signal wData: std_logic_vector(31 downto 0);

    signal rdAddr1: std_logic_vector(4 downto 0);
    signal rdAddr2: std_logic_vector(4 downto 0);
    signal wrAddr: std_logic_vector(4 downto 0);

    signal clk, reset, we: std_logic;

    signal rdData1: std_logic_vector(31 downto 0);
    signal rdData2: std_logic_vector(31 downto 0);
	 
	signal rdAddr1_decimal : integer;
	signal rdAddr1_decimal_ten : integer;
	signal rdAddr1_decimal_unit : integer;
	
	signal rdAddr2_decimal : integer;
	signal rdAddr2_decimal_ten : integer;
	signal rdAddr2_decimal_unit : integer;
    component RegBank is
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
    end component RegBank;
begin 
	
	uut: RegBank port map(
		clk => clk,
		reset => reset,
		rdAddr1 => rdAddr1,
		rdAddr2 => rdAddr2,
		wrAddr => wrAddr,
		wData => wData,
		we => we,
		rdData1 => rdData1,
		rdData2 => rdData2
	);
	
	clk <= NOT(KEY(3));
	we <= NOT(KEY(2));
	reset <= NOT(KEY(1));
	
	LEDR(7 downto 5) <= rdData1(2 downto 0);
   LEDR(2 downto 0) <= rdData2(2 downto 0);
	 
	LEDG(3 downto 0) <= KEY(3 downto 0);
	
    rdAddr1 <= SW(14 downto 10);
    rdAddr2 <= SW(9 downto 5);
    wrAddr <= SW(4 downto 0);
    wData <= "00000000000000000000000000000" & SW(17 downto 15);
	 
	 --Índice registrador 1
		rdAddr1_decimal <= to_integer(unsigned(rdAddr1));
		rdAddr1_decimal_ten <= rdAddr1_decimal / 10;
		with to_unsigned(rdAddr1_decimal_ten,4) select
		HEX7 <= "0000001" when "0000",
			  "1001111" when "0001",
			  "0010010" when "0010",
			  "0000110" when "0011",
			  "1001100" when "0100",
			  "0100100" when "0101",
			  "0100000" when "0110",
			  "0001111" when "0111",
			  "0000000" when "1000",
			  "0000100" when "1001",
			  "0001000" when "1010",
			  "1100000" when "1011",
			  "0110000" when "1100",
			  "1000010" when "1101",
			  "0110000" when "1110",
			  "0111000" when "1111",
			  "1111111" when others;
		
		
		rdAddr1_decimal_unit <= rdAddr1_decimal mod 10;
	  with to_unsigned(rdAddr1_decimal_unit,4) select
		HEX6 <=  "0000001" when "0000",
			  "1001111" when "0001",
			  "0010010" when "0010",
			  "0000110" when "0011",
			  "1001100" when "0100",
			  "0100100" when "0101",
			  "0100000" when "0110",
			  "0001111" when "0111",
			  "0000000" when "1000",
			  "0000100" when "1001",
			  "0001000" when "1010",
			  "1100000" when "1011",
			  "0110000" when "1100",
			  "1000010" when "1101",
			  "0110000" when "1110",
			  "0111000" when "1111",
			  "1111111" when others;
	 
	 --Índice Registrador 2
	 rdAddr2_decimal <= to_integer(unsigned(rdAddr2));
	 rdAddr2_decimal_ten <= rdAddr2_decimal / 10;
	 with to_unsigned(rdAddr2_decimal_ten,4) select
		HEX5 <=  "0000001" when "0000",
			  "1001111" when "0001",
			  "0010010" when "0010",
			  "0000110" when "0011",
			  "1001100" when "0100",
			  "0100100" when "0101",
			  "0100000" when "0110",
			  "0001111" when "0111",
			  "0000000" when "1000",
			  "0000100" when "1001",
			  "0001000" when "1010",
			  "1100000" when "1011",
			  "0110000" when "1100",
			  "1000010" when "1101",
			  "0110000" when "1110",
			  "0111000" when "1111",
			  "1111111" when others;
		
		rdAddr2_decimal_unit <= rdAddr2_decimal mod 10;
		with to_unsigned(rdAddr2_decimal_unit,4) select
		HEX4 <=  "0000001" when "0000",
			  "1001111" when "0001",
			  "0010010" when "0010",
			  "0000110" when "0011",
			  "1001100" when "0100",
			  "0100100" when "0101",
			  "0100000" when "0110",
			  "0001111" when "0111",
			  "0000000" when "1000",
			  "0000100" when "1001",
			  "0001000" when "1010",
			  "1100000" when "1011",
			  "0110000" when "1100",
			  "1000010" when "1101",
			  "0110000" when "1110",
			  "0111000" when "1111",
			  "1111111" when others;
	 
  end architecture bhv;