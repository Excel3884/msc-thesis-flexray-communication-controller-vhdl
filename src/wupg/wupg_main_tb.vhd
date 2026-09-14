LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE tb OF testbench IS
  SIGNAL wupg_en  : std_logic;
  SIGNAL wupg_out : std_logic_vector(44 DOWNTO 0);
  SIGNAL clk      : std_logic := '0';

  SIGNAL sel         : std_logic;
  SIGNAL reset       : std_logic;
  SIGNAL test_output : std_logic;

BEGIN

  wupg_main0 : ENTITY work.wupg_main PORT MAP (wupg_en => wupg_en, wupg_out => wupg_out, clk => clk, test_output => test_output, reset => reset, sel => sel);

  clk <= NOT clk AFTER 10 ns;

  PROCESS
  BEGIN
    -- reset SR FF
    sel <= '0'; -- έξοδος πολυπλέκτη: '1' 
    wupg_en <= '0';
    reset <= '1'; -- reset 2, 4, 5 DFFs
    WAIT FOR 5 ns;
    reset <= '0'; --είναι ασύγχρονο το reset
    sel <= '1'; -- έξοδος πολυπλέκτη: έξοδος πύλης AND
    WAIT FOR 10 ns;
    -- set SR FF
    wupg_en <= '1';
    WAIT FOR 20 ns;
    wupg_en <= '0';
    WAIT FOR 200 ns;

  END PROCESS;

END tb;
