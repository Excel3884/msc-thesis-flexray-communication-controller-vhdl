LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE tb OF testbench IS
  SIGNAL buffer_inv   : std_logic := '0';
  SIGNAL validity_bit : std_logic;
  SIGNAL clk          : std_logic := '0';
  SIGNAL rst          : std_logic;
  SIGNAL curr_state   : std_logic_vector(1 DOWNTO 0);
BEGIN

  vbit_fsm0 : ENTITY work.vbit_fsm PORT MAP (buffer_inv => buffer_inv, validity_bit => validity_bit, clk => clk, rst => rst, curr_state => curr_state);

  clk <= NOT clk AFTER 10 ns;

  PROCESS
  BEGIN
    rst <= '1';
    WAIT FOR 25 ns;

    rst <= '0';
    buffer_inv <= '1';
    WAIT FOR 40 ns;


    buffer_inv <= '0';
    WAIT FOR 25 ns;
  END PROCESS;

END tb;

