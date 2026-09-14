LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE tb OF testbench IS
  SIGNAL clr, en : std_logic;
  SIGNAL clk     : std_logic := '0';
  SIGNAL output  : std_logic_vector(1 DOWNTO 0);
BEGIN

  counter0 : ENTITY work.counter PORT MAP (en => en, clr => clr, clk => clk, output => output);

  clk <= NOT clk AFTER 10 ns;

  en  <= '1';
  clr <= '0';


END tb;
