library ieee;
use ieee.std_logic_1164.all;

entity tdr_TB is
end tdr_TB;

architecture testbench of tdr_TB is
  signal reset_bar_tb, load_bar_tb :  std_logic;
	signal clk_tb : std_logic;
	signal data_in_tb : std_logic_vector(7 downto 0);
	signal data_out_tb : std_logic_vector(7 downto 0);
	signal sim_end : boolean := false;
	signal test_sig : std_logic := '1';
	
	component tdr
	  port(
		reset_bar, load_bar : in std_logic;
		clk : in std_logic;
		data_in : in std_logic_vector(7 downto 0);
		data_out : out std_logic_vector(7 downto 0)
		);
  end component;
  
  constant period : time := 50 ns;
  constant clk_per : time := 10 ns;
  
  
begin
  
  DUT : tdr port map (
    reset_bar => reset_bar_tb,
    load_bar => load_bar_tb,
    clk => clk_tb, 
    data_in => data_in_tb,
    data_out => data_out_tb
  );
  
  clk_proc : process
  begin
    while(not sim_end) loop
      clk_tb <= '1';
      wait for clk_per / 2;
      clk_tb <= '0';
      wait for clk_per / 2;
    end loop;
    wait;
  end process clk_proc;
    
  
  --clk_tb <= not clk_tb after period / 2;
  

    
  stimulus : process
  begin
    test_sig <= '1';
    data_in_tb <= "11110000";
    load_bar_tb <= '1';
    reset_bar_tb <= '1';
    wait for period / 2;
    reset_bar_tb <= '0';
    wait for period;
    reset_bar_tb <= '1';
    wait for period / 2;
    
    load_bar_tb <= '0';
    wait for period /2 ;
    load_bar_tb <= '1';
    wait for period / 2;
    
    wait for period;
    
    data_in_tb <= "00001110";
    wait for period / 2;
    load_bar_tb <= '0';
    wait for period / 2;
    
    load_bar_tb <= '1';
    
    wait for period;
    
    
    data_in_tb <= "10101010";
    wait for period / 2;
    load_bar_tb <= '0';
    wait for period / 2;
    
    load_bar_tb <= '1';
    
    wait for period;
    
    data_in_tb <= "11001111";
    wait for period / 2;
    load_bar_tb <= '0';
    wait for period / 2;
    
    load_bar_tb <= '1';
    
    wait for period;
    
    data_in_tb <= "11111101";
    wait for period / 2;
    load_bar_tb <= '0';
    wait for period / 2;
    
    load_bar_tb <= '1';
    wait;
    
    sim_end <= true;
    
  end process stimulus;
    
    
    
    
  
  
end testbench;
