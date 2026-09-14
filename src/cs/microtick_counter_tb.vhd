LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE tb OF testbench IS
  SIGNAL state        : std_logic_vector(2 DOWNTO 0);
  SIGNAL clk          : std_logic := '0';
  SIGNAL macro_clock  : std_logic := '0';
  SIGNAL global_value : std_logic_vector(3 DOWNTO 0);
  SIGNAL reset_ff     : std_logic;
  SIGNAL test_output  : std_logic_vector(3 DOWNTO 0);
  SIGNAL output       : std_logic_vector(44 DOWNTO 0);
  -- fsm's signals
  SIGNAL rst          : std_logic;
  SIGNAL fsm_state    : std_logic_vector(1 DOWNTO 0);
BEGIN

  microtick_counter0 : ENTITY work.microtick_counter PORT MAP (state => state, clk => clk, macro_clock => macro_clock, global_value => global_value, reset_ff => reset_ff, test_output => test_output, output => output, rst => rst, fsm_state => fsm_state);

  clk          <= NOT clk         AFTER 10 ns;
  macro_clock  <= NOT macro_clock AFTER 82 ns;
  global_value <= "0100";

  PROCESS
  BEGIN
    state    <= "100";                  --set sr ff
    rst      <= '1';                    -- reset vbit fsm
    WAIT FOR 15 ns;
    rst      <= '0';
    state    <= "000";
    reset_ff <= '1';                    -- reset dffs
    WAIT FOR 20 ns;
    reset_ff <= '0';
    -- στα 82 ns ερχεται η πρωτη θετικη ακμη του macro_clock
    WAIT FOR 200 ns;
  END PROCESS;



END tb;
