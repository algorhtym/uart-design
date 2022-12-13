LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tx_fsm IS
  port (
    clk : in std_logic;
    reset_bar : in std_logic;
    transmit : in std_logic;
    tx_rd_dn : in std_logic;
    A, B, C, D : out std_logic;
    cur_st : out std_logic_vector(1 downto 0)
  );
END tx_fsm;

architecture tx_fsm_arch of tx_fsm is 
  -- signal declarations
  signal G : std_logic;
  signal i_cur_st : std_logic_vector(1 downto 0); -- current state variables
  signal i_A, i_B, i_C, i_D : std_logic; -- output vars
  signal i_next_st : std_logic_vector(1 downto 0); -- next state vars
  signal dummy : std_logic_vector(1 downto 0);
  
  
  -- components
  
  component dFF_2 
	 PORT(
		i_d, i_clr	: IN	STD_LOGIC;
		i_set			: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
  END component;
  
begin
  -- components
  u_s1: dFF_2 port map (
    i_d => i_cur_st(1),
    i_clr => reset_bar,
    i_set => '1',
    i_clock => clk,
    o_q => i_next_st(1),
    o_qbar => dummy(1)
  );
  
  u_s0: dFF_2 port map (
    i_d => i_cur_st(0),
    i_clr => reset_bar,
    i_set => '1',
    i_clock => clk,
    o_q => i_next_st(0),
    o_qbar => dummy(0)
  );
  
  
  -- concurrent signal assignments
  
  i_cur_st(1) <= (i_next_st(0) and G) or (i_next_st(1) and i_next_st(0));
  i_cur_st(0) <= (G xor i_next_st(0)) or (not i_next_st(1) and i_next_st(0));
  i_A <= (i_next_st(1) and not i_next_st(0));
  i_B <= (i_next_st(1) and not i_next_st(0));
  i_C <= not i_next_st(0);
  i_D <= i_next_st(1);
  
  -- output driver
  
  A <= i_A; -- TDR/load_bar
  B <= i_B; -- TSR/sh_ld_bar
  C <= i_C; -- TDRE
  D <= i_D; -- CNTR_SR
  cur_st <= i_cur_st;
  
end tx_fsm_arch;