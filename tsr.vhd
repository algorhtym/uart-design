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
		data_out, data_out_bar : out std_logic
	);
end tsr;

architecture tsr_struc of tsr is

-- signals for internal transfer of data to output
signal i_serial : std_logic_vector(7 downto 0);
signal i_data : std_logic_vector(7 downto 0);
signal i_serial_out : std_logic;



component dflipflop is
	port(i_d, i_clk, i_set, i_rst: in STD_LOGIC; 
			o_q, o_qbar : inout STD_LOGIC);
end component;

begin 
	-- DFF to hold bit 7 of data
	bit7 : dflipflop port map (
		i_d => i_data(7),
		i_clk => clk,
		i_rst => reset_bar,
		o_q => i_serial(6)
	);

	-- DFF to hold bit 6 of data
	bit6 : dflipflop port map (
		i_d => i_data(6),
		i_clk => clk,
		i_rst => reset_bar,
		o_q => i_serial(5)
	);

	-- DFF to hold bit 5 of data
	bit5 : dflipflop port map (
		i_d => i_data(5),
		i_clk => clk,
		i_rst => reset_bar,
		o_q => i_serial(4)
	);

	-- DFF to hold bit 4 of data
	bit4 : dflipflop port map (
		i_d => i_data(4),
		i_clk => clk,
		i_rst => reset_bar,
		o_q => i_serial(3)
	);

	-- DFF to hold bit 3 of data
	bit3 : dflipflop port map (
		i_d => i_data(3),
		i_clk => clk,
		i_rst => reset_bar,
		o_q => i_serial(2)
	);

	-- DFF to hold bit 2 of data
	bit2 : dflipflop port map (
		i_d => i_data(2),
		i_clk => clk,
		i_rst => reset_bar,
		o_q => i_serial(1)
	);

	-- DFF to hold bit 1 of data
	bit1 : dflipflop port map (
		i_d => i_data(1),
		i_clk => clk,
		i_rst => reset_bar,
		o_q => i_serial(0)
	);

	-- DFF to hold bit 0 of data
	bit0 : dflipflop port map (
		i_d => i_data(0),
		i_clk => clk,
		i_rst => reset_bar,
		o_q => i_serial_out
	);	

	-- Signal connections
	i_serial(7) <= '1';
	i_data(7) <= (sh_ld_bar and i_serial(7)) or (not sh_ld_bar and data_in(7));
	i_data(6) <= (sh_ld_bar and i_serial(6)) or (not sh_ld_bar and data_in(6));
	i_data(5) <= (sh_ld_bar and i_serial(5)) or (not sh_ld_bar and data_in(5));
	i_data(4) <= (sh_ld_bar and i_serial(4)) or (not sh_ld_bar and data_in(4));
	i_data(3) <= (sh_ld_bar and i_serial(3)) or (not sh_ld_bar and data_in(3));
	i_data(2) <= (sh_ld_bar and i_serial(2)) or (not sh_ld_bar and data_in(2));
	i_data(1) <= (sh_ld_bar and i_serial(1)) or (not sh_ld_bar and data_in(1));
	i_data(0) <= (sh_ld_bar and i_serial(0)) or (not sh_ld_bar and data_in(0));

	-- Output Driver
	data_out <= i_serial_out;
	data_out_bar <= not i_serial_out;
	
end tsr_struc;