library ieee;
use ieee.std_logic_1164.all;


entity mod16counter is
port(
	i_enable	: in std_logic;
	i_clk		: in std_logic;
	i_clr		: in std_logic;
	o_count	: out std_logic_vector(3 downto 0));
end mod16counter;


architecture mod16_arc of mod16counter is

component tFF_2 IS
	PORT(
		i_t, i_clr, i_set	: IN	STD_LOGIC;
		i_clock				: IN	STD_LOGIC;
		o_q, o_qBar			: OUT	STD_LOGIC);
end component;

signal q, t: std_logic_vector(3 downto 0);

begin

tff0:tFF_2 port map(t(0), i_clr, '1', i_clk, q(0));
tff1:tFF_2 port map(t(1), i_clr, '1', i_clk, q(1));
tff2:tFF_2 port map(t(2), i_clr, '1', i_clk, q(2));
tff3:tFF_2 port map(t(3), i_clr, '1', i_clk, q(3));

t(0) <= i_enable;
t(1) <= q(0) and t(0);
t(2) <= q(1) and t(1);
t(2) <= q(2) and t(2);

o_count <= q;

end mod16_arc;
