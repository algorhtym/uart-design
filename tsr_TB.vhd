library ieee;
use ieee.std_logic_1164.all;

entity tsr_TB is
end tsr_TB;

architecture testbench of tsr_TB is 
  
  signal reset_bar_tb, sh_ld_bar_tb : std_logic;
	signal clk_tb : std_logic;
	signal data_in_tb : std_logic_vector(7 downto 0);
	signal data_out_tb : std_logic;
	signal sim_end : boolean := false;
	signal test_sig : std_logic := '1';
  
  
  component tsr
    port (
		  reset_bar, sh_ld_bar : in std_logic;
		  clk : in std_logic;
		  data_in : in std_logic_vector(7 downto 0);
		  data_out : out std_logic
	  );
  end component;
	
	constant period : time := 50 ns;
	constant clk_per : time := 10 ns;
	  
begin
  
  DUT : tsr port map (
    reset_bar => reset_bar_tb,
    sh_ld_bar => sh_ld_bar_tb,
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
  
  stimulus : process
  begin
    test_sig <= '1';
    data_in_tb <= "01110011";
    sh_ld_bar_tb <= '0';
    reset_bar_tb <= '1';
    wait for clk_per * 2;
    reset_bar_tb <= '0';
    wait for clk_per * 2;
    
    reset_bar_tb <= '1';
    
    wait for clk_per * 2;   
    
    
    --sh_ld_bar_tb <= '0';
    
    -- start shifting
    sh_ld_bar_tb <= '1';
    wait for clk_per * 12; 
    test_sig <= not test_sig;
    
    data_in_tb <= "01011001";
    wait for clk_per;
    
    
    -- load the registers
    sh_ld_bar_tb <= '0';
    wait for clk_per;
    -- start shifting
    sh_ld_bar_tb <= '1';
    wait for clk_per * 12;
    test_sig <= not test_sig;
    
    data_in_tb <= "01111001";
    wait for clk_per;
    
    -- load the registers
    sh_ld_bar_tb <= '0';
    wait for clk_per;
    -- start shifting
    sh_ld_bar_tb <= '1';
    wait for clk_per * 12;
    test_sig <= not test_sig;
    
    wait for period * 5;
    
    wait;
    
    sim_end <= true;
  end process stimulus;
    
    
  
end testbench;