library ieee;
use ieee.std_logic_1164.all;

--! This component is the Transmitter Shift Register of the Transmitter component
--! It adopts a PISO architecture, receiving data from the TDR parallelly, 
--! and outputting data serially to the TxD output
entity tsr is
	port (
		reset_bar, sh_ld_bar : in std_logic;
		clk : in std_logic;
		data_in : in std_logic_vector(7 downto 0);
		data_out : out std_logic
	);
end tsr;

architecture tsr_struc of tsr is

-- signals for internal transfer of data to output
signal i_serial : std_logic_vector(7 downto 0);
signal i_data : std_logic_vector(7 downto 0);
signal i_serial_out : std_logic;
signal i_serial_start, i_start_bit, i_start_in : std_logic;
signal i_stop_bit, i_stop_in : std_logic;
signal i_no_transmit : std_logic;



component dflipflop is
	port(i_d, i_clk, i_set, i_rst: in STD_LOGIC; 
			o_q, o_qbar : inout STD_LOGIC);
end component;

begin 

	-- DFF that holds the stop bit ('1') which is sent last to the TxD
	stop_bit : dflipflop port map (
		i_d => i_stop_in,
		i_clk => clk,
		i_set => reset_bar,
		i_rst => '1',
		o_q => i_serial(7)
	);


	-- DFF to hold bit 7 of data
	bit7 : dflipflop port map (
		i_d => i_data(7),
		i_clk => clk,
		i_set => reset_bar,
		i_rst => '1',
		o_q => i_serial(6)
	);

	-- DFF to hold bit 6 of data
	bit6 : dflipflop port map (
		i_d => i_data(6),
		i_clk => clk,
		i_set => reset_bar,
		i_rst => '1',
		o_q => i_serial(5)
	);

	-- DFF to hold bit 5 of data
	bit5 : dflipflop port map (
		i_d => i_data(5),
		i_clk => clk,
		i_set => reset_bar,
		i_rst => '1',
		o_q => i_serial(4)
	);

	-- DFF to hold bit 4 of data
	bit4 : dflipflop port map (
		i_d => i_data(4),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_serial(3)
	);

	-- DFF to hold bit 3 of data
	bit3 : dflipflop port map (
		i_d => i_data(3),
		i_clk => clk,
		i_set => reset_bar,
		i_rst => '1',
		o_q => i_serial(2)
	);

	-- DFF to hold bit 2 of data
	bit2 : dflipflop port map (
		i_d => i_data(2),
		i_clk => clk,
		i_set => reset_bar,
		i_rst => '1',
		o_q => i_serial(1)
	);

	-- DFF to hold bit 1 of data
	bit1 : dflipflop port map (
		i_d => i_data(1),
		i_clk => clk,
		i_set => reset_bar,
		i_rst => '1',
		o_q => i_serial(0)
	);

	-- DFF to hold bit 0 of data
	bit0 : dflipflop port map (
		i_d => i_data(0),
		i_clk => clk,
		i_set => reset_bar,
		i_rst => '1',
		o_q => i_serial_start
	);	
	
	-- DFF that holds the start bit ('0') which be sent to the TxD first
	-- Note that for this component, reset_bar is connected to the i_set instead of
	-- i_rst, to achieve high TxD signal on reset
	start_bit : dflipflop port map (
		i_d => i_start_in,
		i_clk => clk,
		i_set => reset_bar,
		i_rst => '1',
		o_q => i_serial_out
	);



	-- Signal connections
	i_stop_bit <= '1';
	i_stop_in <= (sh_ld_bar) or (not sh_ld_bar and i_stop_bit);
	i_data(7) <= (sh_ld_bar and i_serial(7)) or (not sh_ld_bar and data_in(7));
	i_data(6) <= (sh_ld_bar and i_serial(6)) or (not sh_ld_bar and data_in(6));
	i_data(5) <= (sh_ld_bar and i_serial(5)) or (not sh_ld_bar and data_in(5));
	i_data(4) <= (sh_ld_bar and i_serial(4)) or (not sh_ld_bar and data_in(4));
	i_data(3) <= (sh_ld_bar and i_serial(3)) or (not sh_ld_bar and data_in(3));
	i_data(2) <= (sh_ld_bar and i_serial(2)) or (not sh_ld_bar and data_in(2));
	i_data(1) <= (sh_ld_bar and i_serial(1)) or (not sh_ld_bar and data_in(1));
	i_data(0) <= (sh_ld_bar and i_serial(0)) or (not sh_ld_bar and data_in(0));
	i_start_bit <= '0';
	i_start_in <= (sh_ld_bar and i_serial_start) or (not sh_ld_bar and i_start_bit);
  i_no_transmit <= '1';

	-- Output Driver
	data_out <= (i_serial_out and sh_ld_bar) or (i_no_transmit and not sh_ld_bar);
	
	
end tsr_struc;