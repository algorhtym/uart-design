library ieee;
use ieee.std_logic_1164.all;

entity tdr is
	port(
		reset_bar, load : in std_logic;
		clk : in std_logic;
		data_in : in std_logic_vector(7 downto 0);
		data_out : out std_logic_vector(7 downto 0)
		);
end tdr;

architecture tdr_struc of tdr is

signal i_data, i_data_bar : std_logic_vector(7 downto 0);


component dflipflop is
	port(i_d, i_clk, i_set, i_rst: in STD_LOGIC; 
			o_q, o_qbar : inout STD_LOGIC);
end component;

begin
	-- DFF to hold bit 7 of data
	bit7 : dflipflop port map (
		i_d => data_in(7),
		i_clk => clk,
		i_rst => reset_bar,
		o_q => i_data(7),
		o_qbar => i_data_bar(7)
	);

	-- DFF to hold bit 6 of data
	bit6 : dflipflop port map (
		i_d => data_in(6),
		i_clk => clk,
		i_rst => reset_bar,
		o_q => i_data(6),
		o_qbar => i_data_bar(6)
	);

	-- DFF to hold bit 5 of data
	bit5 : dflipflop port map (
		i_d => data_in(5),
		i_clk => clk,
		i_rst => reset_bar,
		o_q => i_data(5),
		o_qbar => i_data_bar(5)
	);

	-- DFF to hold bit 4 of data
	bit4 : dflipflop port map (
		i_d => data_in(4),
		i_clk => clk,
		i_rst => reset_bar,
		o_q => i_data(4),
		o_qbar => i_data_bar(4)
	);

	-- DFF to hold bit 3 of data
	bit3 : dflipflop port map (
		i_d => data_in(3),
		i_clk => clk,
		i_rst => reset_bar,
		o_q => i_data(3),
		o_qbar => i_data_bar(3)
	);

	-- DFF to hold bit 2 of data
	bit2 : dflipflop port map (
		i_d => data_in(2),
		i_clk => clk,
		i_rst => reset_bar,
		o_q => i_data(2),
		o_qbar => i_data_bar(2)
	);

	-- DFF to hold bit 1 of data
	bit1 : dflipflop port map (
		i_d => data_in(1),
		i_clk => clk,
		i_rst => reset_bar,
		o_q => i_data(1),
		o_qbar => i_data_bar(1)
	);

	-- DFF to hold bit 0 of data
	bit0 : dflipflop port map (
		i_d => data_in(0),
		i_clk => clk,
		i_rst => reset_bar,
		o_q => i_data(0),
		o_qbar => i_data_bar(0)
	);

	-- Output Driver:
	data_out <= i_data;

end tdr_struc;