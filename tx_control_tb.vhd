library ieee;
use ieee.std_logic_1164.all;

entity tx_control_TB is
end tx_control_TB;

architecture tx_control_TB_arch of tx_control_TB is
  
  -- signal declarations
  signal transmit_tb : std_logic;
  signal reset_bar_tb : std_logic;
  signal clk_tb : std_logic;
  signal data_bus_tb : std_logic_vector(7 downto 0);
  signal tx_out_tb : std_logic   ;
  signal tdre_tb : std_logic;
  signal sim_end : boolean := false;
  signal test_sig : std_logic := '1';
    
  -- component declarations
  
  component tx_control
    port (
      transmit : in std_logic;
      reset_bar : in std_logic;
      clk : in std_logic;
      data_bus : in std_logic_vector(7 downto 0);
      tx_out : out std_logic   ;
      tdre : out std_logic
    );
  end component;
  
  constant clk_per : time := 10 ns;
  
begin 
  
  -- component connections
  
  dut : tx_control port map (
    transmit => transmit_tb,
    reset_bar => reset_bar_tb,
    clk => clk_tb,
    data_bus => data_bus_tb,
    tx_out => tx_out_tb,
    tdre => tdre_tb
  );
  
  -- clock declaration
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
    wait for clk_per /2 ;
    test_sig <= '1';
    transmit_tb <= '0';
    reset_bar_tb <= '1';
    data_bus_tb <= "11110000";
    wait for clk_per * 2;
    
    reset_bar_tb <= '0';
    wait for clk_per;
    reset_bar_tb <= '1';
    transmit_tb <= '1';
    wait for clk_per * 30;
    
    
    sim_end <= true;
  end process stimulus;
    
end tx_control_TB_arch;
