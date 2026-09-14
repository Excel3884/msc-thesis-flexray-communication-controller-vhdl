LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE tb OF testbench IS
  SIGNAL clr : std_logic;
  SIGNAL clk     : std_logic := '0';
  SIGNAL input   : std_logic_vector(44 DOWNTO 0);
  SIGNAL output  : std_logic_vector(43 DOWNTO 0);
BEGIN
  fid_gen0 : ENTITY work.fid_gen PORT MAP (clr => clr, clk => clk, input => input, output => output);

  clk <= NOT clk AFTER 10 ns;

  PROCESS
  BEGIN
    --clear counter
    clr <= '1';
    WAIT FOR 25 ns;

    clr   <= '0';
    input <= "101010010100101101011010110101101011010100101";
    WAIT FOR 20 ns;

    input <= "101010010100101101011010110101101011010100100";
    WAIT FOR 20 ns;

    input <= "101010010100101101011010110101101011010100101";
    WAIT FOR 20 ns;

    input <= "101010010100101101011010110101101011010100101";
    WAIT FOR 20 ns;
  END PROCESS;

END tb;
