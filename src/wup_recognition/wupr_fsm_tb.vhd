LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE tb OF testbench IS
  SIGNAL symbol     : std_logic_vector(3 DOWNTO 0);
  SIGNAL clk        : std_logic := '0';
  SIGNAL rst        : std_logic;
  SIGNAL wup_found  : std_logic;
  SIGNAL curr_state : std_logic_vector(2 DOWNTO 0);
BEGIN

  wupr_fsm0 : ENTITY work.wupr_fsm PORT MAP (symbol => symbol, clk => clk, rst => rst, wup_found => wup_found, curr_state => curr_state);

  clk <= NOT clk AFTER 10 ns;

  PROCESS
  BEGIN

    rst    <= '1';
    symbol <= "0000";
    WAIT FOR 25 ns;

    rst    <= '0';
    symbol <= "1010";
    WAIT FOR 20 ns;

    symbol <= "0101";
    WAIT FOR 20 ns;

    symbol <= "1010";
    WAIT FOR 20 ns;

    symbol <= "1111";
    WAIT FOR 20 ns;

    symbol <= "0010";
    WAIT FOR 20 ns;

    symbol <= "0111";
    WAIT FOR 200 ns;

  END PROCESS;

END tb;
