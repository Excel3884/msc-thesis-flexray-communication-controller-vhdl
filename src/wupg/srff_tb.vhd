LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE tb OF testbench IS
  SIGNAL set, rst : std_logic;
  SIGNAL clk      : std_logic := '0';
  SIGNAL q        : std_logic;
BEGIN

  srff0 : ENTITY work.srff PORT MAP (set => set, rst => rst, clk => clk, q => q);
  clk <= NOT clk AFTER 10 ns;

  PROCESS
  BEGIN
    rst <= '1';
    set <= '0';
    WAIT FOR 15 ns;
    rst <= '0';
    set <= '1';
    wait for 20 ns;
    
  END PROCESS;


END tb;
