LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE tb OF testbench IS
  SIGNAL sel     : std_logic_vector(1 DOWNTO 0);
  SIGNAL a, b, c : std_logic_vector(44 DOWNTO 0);
  SIGNAL output  : std_logic_vector(44 DOWNTO 0);

BEGIN
  mux0 : ENTITY work.mux PORT MAP (sel => sel, a => a, b => b, c => c, output => output);

  a <= (5 => '1', OTHERS => '0');
  b <= (2 => '1', OTHERS => '0');
  c <= (3 => '1', OTHERS => '0');
  PROCESS
  BEGIN

    WAIT FOR 10 ns;

    sel <= "00";
    WAIT FOR 10 ns;

    sel <= "01";
    WAIT FOR 10 ns;

    sel <= "10";
    WAIT FOR 10 ns;
  END PROCESS;

END tb;
