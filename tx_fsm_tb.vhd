library ieee;
use ieee.std_logic_1164.all;

entity tx_fsm_TB is
end tx_fsm_TB;

architecture fsm_arch of tx_fsm_TB is
  signal clk_tb : std_logic;
  signal reset_bar_tb : std_logic;
  signal transmit_tb : std_logic;
  signal tx_rd_dn_tb : std_logic;
  signal A_tb, B_tb, C_tb, D_tb : std_logic;
  signal cur_st_tb : std_logic_vector(1 downto 0);
  
  signal sim_end : boolean := false;
	signal test_sig : std_logic := '1';
  
  component tx_fsm
    port (
      clk : in std_logic;
      reset_bar : in std_logic;
      transmit : in std_logic;
      tx_rd_dn : in std_logic;
      A, B, C, D : out std_logic;
      cur_st : out std_logic_vector(1 downto 0)
    );
  end component;
  
  constant clk_per : time := 10 ns;
  
begin
  
  dut : tx_fsm port map(
    clk => clk_tb,
    reset_bar => reset_bar_tb,
    transmit => transmit_tb,
    tx_rd_dn => tx_rd_dn_tb,
    A => A_tb, B => B_tb, C => C_tb, D => D_tb,
    cur_st => cur_st_tb
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
    wait for clk_per /  2;
    test_sig <= '1';
    transmit_tb <= '0';
    reset_bar_tb <= '1';
    tx_rd_dn_tb <= '0';
    wait for clk_per * 2;
    
    reset_bar_tb <= '0';
    wait for clk_per * 3;
    reset_bar_tb <= '1';
    wait for clk_per * 2;
    
    transmit_tb <= '1';
    tx_rd_dn_tb <= '1';
    
    wait for clk_per * 30;
    
    
    
    
    sim_end <= true;
  end process stimulus;
  
    
    
end fsm_arch;    

