-- counter.vhd
-- Copyright (C) 2015 Jan Viktorin

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
generic (
	WIDTH : positive := 32
);
port (
	CLK   : in  std_logic;
	RESET : in  std_logic;

	CE    : in  std_logic;
	VALUE : out unsigned(WIDTH - 1 downto 0)
);
end entity;

architecture full of counter is

	signal cnt_value : unsigned(VALUE'range);
	signal cnt_ce    : std_logic;

begin

	cnt_valuep: process(CLK)
	begin
		if rising_edge(CLK) then
			if RESET = '1' then
				cnt_value <= (others => '0');
			elsif cnt_ce = '1' then
				cnt_value <= cnt_value + 1;
			end if;
		end if;
	end process;

	cnt_ce <= CE;
	VALUE  <= cnt_value;

end architecture;
