LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE tb OF testbench IS
  SIGNAL sel     : std_logic_vector(1 DOWNTO 0);
  SIGNAL input   : std_logic_vector(43 DOWNTO 0);
  SIGNAL a, b, c : std_logic_vector(43 DOWNTO 0);
BEGIN
  demux0 : ENTITY work.demux PORT MAP (sel => sel, input => input, a => a, b => b, c => c);

  input <= (2 => '1', OTHERS => '0');
  PROCESS
  BEGIN
    WAIT FOR 10 ns;
    sel <= "10";
    WAIT FOR 10 ns;
    sel <= "00";
    WAIT FOR 10 ns;
    sel <= "01";
    WAIT FOR 10 ns;

  END PROCESS;



END tb;
