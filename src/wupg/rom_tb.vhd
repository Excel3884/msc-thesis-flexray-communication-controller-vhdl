LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE tb OF testbench IS
  SIGNAL addr : std_logic_vector(1 DOWNTO 0);
  SIGNAL output : std_logic_vector(3 DOWNTO 0);
  SIGNAL clk : std_logic := '0';
  SIGNAL oe : std_logic;
BEGIN

  room0 : ENTITY work.rom PORT MAP (addr => addr, output => output, oe => oe, clk => clk);

  clk <= NOT clk AFTER 10 ns;
  oe <= '1';

  addr <= "10";

END tb;
