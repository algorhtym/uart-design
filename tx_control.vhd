library ieee;
use ieee.std_logic_1164.all;

entity tx_control is
    port (
      transmit : in std_logic;
      reset_bar : in std_logic;
      clk : in std_logic;
      data_bus : in std_logic_vector(7 downto 0);
      tx_out : out std_logic   ;
      tdre : out std_logic
    );
end tx_control;




architecture struc_tx_control of tx_control is
  


  -- signal declarations
  
  signal i_tx_ready_done : std_logic;
  signal i_TDR_load_bar : std_logic := '1';
  signal i_TSR_sh_ld_bar : std_logic := '1';
  signal i_tdre : std_logic := '1';
  signal i_cnt_res : std_logic; 
  signal i_cnt_start : std_logic;
  signal i_compare_val: std_logic_vector(3 downto 0);
  signal cntr_val : std_logic_vector(3 downto 0);
  signal i_tx_out : std_logic;
  signal i_cur_st : std_logic_vector(1 downto 0);
  signal i_tsr_in : std_logic_vector(7 downto 0);
  signal gt, eq, lt : std_logic;
  signal comp_sig : std_logic_vector(3 downto 0);
  

  -- component declarations
  component tx_fsm 
    port (
      clk : in std_logic;
      reset_bar : in std_logic;
      transmit : in std_logic;
      tx_rd_dn : in std_logic;
      A, B, C, D : out std_logic;
      cur_st : out std_logic_vector(1 downto 0)
    );
  END component;
  
  component tdr
	  port(
		reset_bar, load_bar : in std_logic;
		clk : in std_logic;
		data_in : in std_logic_vector(7 downto 0);
		data_out : out std_logic_vector(7 downto 0)
		);
  end component;
  
  component tsr
    port (
		  reset_bar, sh_ld_bar : in std_logic;
		  clk : in std_logic;
		  data_in : in std_logic_vector(7 downto 0);
		  data_out : out std_logic
	  );
  end component;
  
  component mod16counter
    port(
	   i_enable	: in std_logic;
	   i_clk		: in std_logic;
	   i_clr		: in std_logic;
	   o_count	: out std_logic_vector(3 downto 0));
  end component;
  
  
  component comparator_4bit
	  PORT(
		  i_Ai, i_Bi			: IN	STD_LOGIC_VECTOR(3 downto 0);
		  o_GT, o_LT, o_EQ		: OUT	STD_LOGIC);
  END component;
  
  component dLatch
	   PORT(
		  i_d		: IN	STD_LOGIC;
		  i_enable	: IN	STD_LOGIC;
		  o_q, o_qBar	: OUT	STD_LOGIC);
  END component;


begin
    -- components
    
    u_tx_fsm : tx_fsm port map(
      clk => clk,
      reset_bar => reset_bar,
      transmit => transmit,
      tx_rd_dn => i_tx_ready_done,
      A => i_TDR_load_bar, 
      B => i_TSR_sh_ld_bar, 
      C => i_tdre, 
      D => i_cnt_res,
      cur_st => i_cur_st
    );
    
    u_tdr : tdr port map (
      reset_bar => reset_bar, 
      load_bar => i_tdr_load_bar,
		  clk => clk,
		  data_in => data_bus,
		  data_out => i_tsr_in
    );
    
    u_tsr : tsr port map (
      reset_bar => reset_bar, 
      sh_ld_bar => i_TSR_sh_ld_bar,
		  clk => clk,
		  data_in => i_tsr_in,
		  data_out => i_tx_out
    );
    
    u_cntr : mod16counter port map (
      i_enable	=> i_cnt_start,
      i_clk		=> clk,
      i_clr		=> i_cnt_start,
      o_count	=> cntr_val
    );
    
    u_comparator : comparator_4bit port map (
      i_Ai => cntr_val, 
      i_Bi	=> i_compare_val,
		  o_GT => gt,
		  o_LT => lt, 
		  o_EQ	=> eq
    );

    -- signal connections
    i_cnt_start <= i_cnt_res;
    
    -- in state 2, tx_ready if cntr == 0000; in state 3, tx_done if cntr >= 1100
    i_tx_ready_done <= (not i_cnt_res and eq) or (i_cnt_res and (gt or eq));
    
    -- put 0000 in the comparator in state 2, 1100 in state 3 
    comp_sig(3) <= i_cnt_res;
    comp_sig(2) <= i_cnt_res;
    comp_sig(1) <= i_cnt_res;
    comp_sig(0) <= i_cnt_res;
    i_compare_val <= (not comp_sig and "0000") or (comp_sig and "1100");
    

    -- output driver
    tdre <= i_tdre;
    tx_out <= i_tx_out;

end struc_tx_control;