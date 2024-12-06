library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regbank_tb is
end entity regbank_tb;

architecture simu of regbank_tb is
    signal clk     : std_logic := '0';
    signal reset   : std_logic := '0';
    signal rdAddr1 : std_logic_vector(4 downto 0) := (others => '0');
    signal rdAddr2 : std_logic_vector(4 downto 0) := (others => '0');
    signal wrAddr  : std_logic_vector(4 downto 0) := (others => '0');
    signal wData   : std_logic_vector(31 downto 0) := (others => '0');
    signal we      : std_logic := '0';
    signal rdData1 : std_logic_vector(31 downto 0);
    signal rdData2 : std_logic_vector(31 downto 0);

    -- Instância do banco de registradores
    component RegBank is
        port (
            clk     : in  std_logic;
            reset   : in  std_logic;
            rdAddr1 : in  std_logic_vector(4 downto 0);
            rdAddr2 : in  std_logic_vector(4 downto 0);
            wrAddr  : in  std_logic_vector(4 downto 0);
            wData   : in  std_logic_vector(31 downto 0);
            we      : in  std_logic;
            rdData1 : out std_logic_vector(31 downto 0);
            rdData2 : out std_logic_vector(31 downto 0)
        );
    end component;

begin
    UUT: RegBank port map (
        clk     => clk,
        reset   => reset,
        rdAddr1 => rdAddr1,
        rdAddr2 => rdAddr2,
        wrAddr  => wrAddr,
        wData   => wData,
        we      => we,
        rdData1 => rdData1,
        rdData2 => rdData2
    );

    process
    begin
        wait for 5 ns;
        clk <= not clk;
    end process;

    process
    begin
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait for 10 ns;
		
		--20 ns
		
        -- Gera um valor aleatório a cada iteração nos registradores
        -- Cada registrador recebe o valor de seu indice (exemplo: registrador 1 recebe 1, reg. 2 recebe 2,...)
		  for i in 0 to 31 loop
				wrAddr <=  std_logic_vector(to_unsigned(i,5));
            wData <= std_logic_vector(to_unsigned(i,32));
				we <= '1';
				wait for 10 ns;
            we <= '0';
            wait for 10 ns;
        end loop;
        --Agora que os valores foram gerados, vamos fazer a leitura deles e checar se está correto
		  
		  -- 340 ns
		  
			--Seleciona no address 1 e checa se é igual ao i
		  for j in 0 to 31 loop
			rdAddr1 <= std_logic_vector(to_unsigned(j,5));
			 wait for 10 ns; 
		   assert j = to_integer(unsigned(rdData1)) report "Invalido";
			wait for 10 ns;
		  end loop;
		  
		  -- 660 ns
		  
        wait;
    end process;
end architecture simu;
