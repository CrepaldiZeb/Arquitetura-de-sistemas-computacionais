library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_board is
    port (
        LEDR: out std_logic_vector(17 downto 0);
        SW: in std_logic_vector(17 downto 0);
        HEX7: out std_logic_vector(0 to 6);
		  HEX6: out std_logic_vector(0 to 6);
		  HEX5: out std_logic_vector(0 to 6);
		  HEX4: out std_logic_vector(0 to 6);
		  HEX3 : out std_logic_vector(0 to 6);
		  HEX2 : out std_logic_vector(0 to 6);
		  HEX1 : out std_logic_vector(0 to 6);
		  HEX0: out std_logic_vector(0 to 6);
        KEY: in std_logic_vector(3 downto 0)
    );
end entity ula_board;

architecture bhv of ula_board is
    signal a, b: std_logic_vector(31 downto 0);
    signal aluctl: std_logic_vector(3 downto 0);
    signal r: std_logic_vector(31 downto 0);
    signal zero, overflow, cout: std_logic;
	 
	 signal decimal_a : integer;
	 signal unit_a : integer;
	
	signal decimal_b : integer;
	signal unit_b : integer;
	
	signal first_decimal_r : integer;
	signal second_decimal_r : integer;
	signal unit_r : integer;
	
    component ULA
        port (
            a      : in    std_logic_vector(31 downto 0);
            b      : in    std_logic_vector(31 downto 0);
            aluctl : in    std_logic_vector(3 downto 0);
            r      : out   std_logic_vector(31 downto 0);
            zero   : out   std_logic;
            overflow : out std_logic;
            cout   : out   std_logic
        );
    end component ULA;

begin
    -- Entrada a e b. Reajusta para 99.
    a <="0000000000000000000000000"  & SW(13 downto 7);
	 b <= "0000000000000000000000000" & SW(6 downto 0);
    aluctl <= SW(17 downto 14);
	
    uut: ULA port map(
        a => a,
        b => b,
        aluctl => aluctl,
        r => r,
        zero => zero,
        overflow => overflow,
        cout => cout
    );

    -- Mapeamento das saídas da ULA para os LEDs
    LEDR(0) <= zero;
    LEDR(1) <= overflow;
    LEDR(2) <= cout;
    LEDR(17 downto 3) <= SW(17 downto 3);	
	 
		--Exibição do A
		decimal_a <= to_integer(unsigned(a)/10);
		with r (31 downto 28) select
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
			  
		--Exibição do segundo digito do A
		unit_a <= to_integer(unsigned(a) mod 10);
		with to_unsigned(unit_a, 4) select
		HEX6 <= "0000001" when "0000",
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
			  
		--Exibição do primeiro digito do B
	decimal_b <= to_integer(unsigned(b)/10);
	with (to_unsigned(decimal_b, 4)) select
	HEX5 <= "0000001" when "0000",
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
					 
			--Exibição do segundo digito do B
	unit_b <= to_integer(unsigned(b) mod 10);
	with (to_unsigned(unit_b, 4)) select
	HEX4 <= "0000001" when "0000",
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
	
	--Exibição de qual operação está sendo feita.
	HEX3 <= "1111110" when to_integer(signed(r)) < 0
	else "1111111";
	
	--Primeiro algarismo do r
	with r(11 downto 8) select
	HEX2 <= "0000001" when "0000",
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
			  
	--Segundo algarismo do r
		
	with r (7 downto 4) select
	HEX1 <=  "0000001" when "0000",
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
	
	--Algarismo menos significativo de r
	with r(3 downto 0) select
	HEX0  <= "0000001" when "0000",
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