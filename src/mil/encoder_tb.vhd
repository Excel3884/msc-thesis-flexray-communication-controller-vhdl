LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE tb OF testbench IS
  SIGNAL input  : std_logic_vector(54 DOWNTO 0);
  SIGNAL en     : std_logic := '1';
  SIGNAL clk    : std_logic := '0';
  SIGNAL output : std_logic_vector(43 DOWNTO 0);
BEGIN
  decoder : ENTITY work.decoder PORT MAP (input => input, en => en, clk => clk, output => output);

  clk <= NOT clk AFTER 10 ns;
  PROCESS
  BEGIN
    input(54 DOWNTO 50) <= "10011";
    WAIT FOR 25 ns;
  END PROCESS;


END tb;
