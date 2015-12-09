-- counter_test.vhd
-- Copyright (C) 2015 Jan Viktorin

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_test is
end entity;

architecture test of counter_test is

	signal clk   : std_logic := '0';
	signal reset : std_logic := '1';

begin

	clkgen: process
	begin
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
	end process;

	rstgen: process
	begin
		reset <= '1';

		for i in 0 to 10 loop
			wait until rising_edge(clk);
		end loop;

		reset <= '0';

		wait;
	end process;

test_counters: for i in 4 to 14 generate

	signal ce    : std_logic;
	signal value : unsigned(i - 1 downto 0);

begin
	uut_i: entity work.counter
	generic map (
		WIDTH => i	
	)
	port map (
		CLK   => clk,
		RESET => reset,
		CE    => ce,
		VALUE => value
	);

	test_i: process(clk)
		variable test_cnt : natural := 0;
	begin
		if rising_edge(clk) then
			assert test_cnt = to_integer(value)
				report "test failed("
				     & integer'image(i) & "):"
				     & " expected "
				     & integer'image(test_cnt)
				     & " but got "
				     & integer'image(to_integer(value))
				severity failure;

			if reset = '1' then
				test_cnt := 0;
			elsif ce = '1' then
				test_cnt := (test_cnt + 1) mod 2**i;
			end if;
		end if;
	end process;

	ce_i: process
	begin
		ce <= '0';

		wait until reset = '0';

		for i in 0 to 2 loop
			wait until rising_edge(clk);
		end loop;

		ce <= '1';

		for i in 0 to 6 loop
			wait until rising_edge(clk);
		end loop;

		ce <= '0';

		wait until rising_edge(clk);

		ce <= '1';

		wait;
	end process;

end generate;

end architecture;
