LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE tb OF testbench IS
  SIGNAL d   : std_logic_vector(0 DOWNTO 0);
  SIGNAL q   : std_logic_vector(0 DOWNTO 0);
  SIGNAL clk : std_logic := '0';
  SIGNAL rst : std_logic;
  SIGNAL en  : std_logic;
BEGIN
  df0 : ENTITY work.dff PORT MAP (d => d, q => q, clk => clk, rst => rst, en => en);

  clk <= NOT clk AFTER 10 ns;

  PROCESS
  BEGIN
    en  <= '0';
    d   <= (OTHERS => '1');
    rst <= '0';
    WAIT FOR 25 ns;
    en  <= '1';
    WAIT FOR 30 ns;
    rst <= '1';
    WAIT FOR 25 ns;

  END PROCESS;


END tb;
