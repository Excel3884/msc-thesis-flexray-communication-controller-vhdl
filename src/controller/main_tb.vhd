LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE tb OF testbench IS

  --ΘΥΡΕΣ

  -- θύρες στη μεριά του Host/Microcontroller
  SIGNAL command_in : std_logic_vector(1 DOWNTO 0);

  SIGNAL clk     : std_logic := '0';
  SIGNAL mil_clk : std_logic := '0';    -- ρολόι για το Medium Interface Layer

  SIGNAL status_data : std_logic_vector(49 DOWNTO 0);

  SIGNAL frame_id     : std_logic_vector(4 DOWNTO 0);
  SIGNAL data_length  : std_logic_vector(4 DOWNTO 0);
  SIGNAL type_of_data : std_logic_vector(1 DOWNTO 0);
  SIGNAL data         : std_logic_vector(31 DOWNTO 0);
  SIGNAL validity_bit : std_logic;

  -- θύρες στη μεριά του FlexRay Bus Driver
  SIGNAL data_out : std_logic_vector(54 DOWNTO 0);
  SIGNAL data_in  : std_logic_vector(54 DOWNTO 0);

  -----------------------------------------------------------

  -- βοηθητικά εσωτερικά σήματα για τη λειτουργία του testbench

  -- pmm
  SIGNAL fsm_rst : std_logic;           -- external
  SIGNAL reg_rst : std_logic;           -- external

  -- cs
  SIGNAL macro_clock  : std_logic := '0';              -- external
  SIGNAL global_value : std_logic_vector(3 DOWNTO 0);  --external
  SIGNAL reset_ff     : std_logic;                     -- external
  SIGNAL test_output  : std_logic_vector(3 DOWNTO 0);  --external
  SIGNAL rst          : std_logic;                     -- external
  SIGNAL fsm_state    : std_logic_vector(1 DOWNTO 0);  -- external

  -- mil
  SIGNAL test_err : std_logic;          -- external
  SIGNAL mil_rst  : std_logic;          --external

  -- wupr
  SIGNAL wupr_fsm_rst : std_logic;      -- external
  SIGNAL wup_found    : std_logic;      -- external, προοριζόμενο για το CHI

  -- wupg
  SIGNAL sel              : std_logic;                      -- external
  SIGNAL reset            : std_logic;                      -- external
  SIGNAL wupg_test_output : std_logic;                      -- external
  SIGNAL wupg_output      : std_logic_vector(44 DOWNTO 0);  --external

BEGIN
  controller : ENTITY work.controller PORT MAP (command_in => command_in, clk => clk, status_data => status_data, frame_id => frame_id, data_length => data_length, type_of_data => type_of_data, data => data, validity_bit => validity_bit, data_out => data_out, data_in => data_in, ext_fsm_rst => fsm_rst, ext_reg_rst => reg_rst, ext_macro_clock => macro_clock, ext_global_value => global_value, ext_reset_ff => reset_ff, ext_test_output => test_output, ext_rst => rst, ext_fsm_state => fsm_state, ext_test_err => test_err, ext_mil_rst => mil_rst, ext_wupr_fsm_rst => wupr_fsm_rst, ext_wup_found => wup_found, ext_sel => sel, ext_reset => reset, ext_wupg_test_output => wupg_test_output, ext_wupg_output => wupg_output, mil_clk => mil_clk);

  clk         <= NOT clk         AFTER 10 ns;
  mil_clk     <= clk;
  macro_clock <= NOT macro_clock AFTER 100 ns;
--  PROCESS (clk)
--  BEGIN
--    IF (clk'event) THEN
--      mil_clk <= NOT mil_clk AFTER 5 ns;
--    END IF;
--  END PROCESS;

  reg_rst      <= '0';                  -- για τον καταχωρητή στο pmm
  mil_rst      <= '0';                  -- για τους καταχωρητές εντός του mil
  validity_bit <= '0';  -- ψηφίο εγκυρότητας για πλαίσιο από τον host

  global_value <= "0101"; -- επιθυμητός αριθμός microticks για επιτυχή συγχρονισμό


  PROCESS
  BEGIN
    --reset to set state to default_config
    fsm_rst <= '1';

    -- reset dffs inside cs (to get validity bit = 0/Z in mil)
    reset_ff <= '1';
    -- reset vbit fsm
    rst      <= '1';


    command_in <= "ZZ";

    WAIT FOR 25 ns;

    reset_ff <= '0';
    rst      <= '0';

    -- command: config
    fsm_rst    <= '0';
    command_in <= "10";

    WAIT FOR 100 ns;  -- όταν βρεθεί σε κατάσταση sleep και λάβουμε config_ack=1

    -- command: wakeup
    command_in <= "00";
    WAIT FOR 30 ns;

    -- αρχικοποίηση wakeup pattern generator 
    sel   <= '0';
    reset <= '1';
    WAIT FOR 5 ns;
    reset <= '0';
    sel   <= '1';

    WAIT FOR 260 ns; -- μετά την αποστολή των πλαισίων
    -- (δεν είναι αναγκαία η αναμονή, αλλά το κάνω για 
    -- τη διευκόλυνση οπτικοποίησης των αποτελεσμάτων)

    -- command: startup
    command_in <= "01";
    WAIT FOR 310 ns;

    --αφού είναι σε κατάσταση active
    -- command: halt
    command_in <= "11";


    WAIT FOR 400 ns;

  END PROCESS;

END tb;
