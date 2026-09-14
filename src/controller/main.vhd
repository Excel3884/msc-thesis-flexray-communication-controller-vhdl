LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY controller IS
  PORT (
    --ΘΥΡΕΣ 
    -- θύρες στη μεριά του Host/Microcontroller
    command_in : IN std_logic_vector(1 DOWNTO 0);

    clk     : IN std_logic;
    mil_clk : IN std_logic;

    status_data : OUT std_logic_vector(49 DOWNTO 0);

    frame_id     : IN std_logic_vector(4 DOWNTO 0);
    data_length  : IN std_logic_vector(4 DOWNTO 0);
    type_of_data : IN std_logic_vector(1 DOWNTO 0);
    data         : IN std_logic_vector(31 DOWNTO 0);
    validity_bit : IN std_logic;


    -- θύρες στη μεριά του FlexRay Bus Driver
    data_out : OUT std_logic_vector(54 DOWNTO 0);
    data_in  : IN  std_logic_vector(54 DOWNTO 0);

    -----------------------------------------------

    -- βοηθητικά εσωτερικά σήματα για τη λειτουργία του testbench

    -- pmm
    ext_fsm_rst : IN std_logic;
    ext_reg_rst : IN std_logic;

    -- cs
    ext_macro_clock  : IN  std_logic;
    ext_global_value : IN  std_logic_vector(3 DOWNTO 0);
    ext_reset_ff     : IN  std_logic;
    ext_test_output  : OUT std_logic_vector(3 DOWNTO 0);
    ext_rst          : IN  std_logic;
    ext_fsm_state    : OUT std_logic_vector(1 DOWNTO 0);

    -- mil
    ext_test_err : OUT std_logic;
    ext_mil_rst  : IN  std_logic;

    -- wupr
    ext_wupr_fsm_rst : IN  std_logic;
    ext_wup_found    : OUT std_logic;

    -- wupg
    ext_sel              : IN  std_logic;
    ext_reset            : IN  std_logic;
    ext_wupg_test_output : OUT std_logic;
    ext_wupg_output      : OUT std_logic_vector(44 DOWNTO 0)




    );
END controller;

ARCHITECTURE default OF controller IS
  COMPONENT chi IS
    PORT (
      -- input, direction: micro => communication
      command_in   : IN  std_logic_vector(1 DOWNTO 0);
      --corresponding output
      command_out  : OUT std_logic_vector(1 DOWNTO 0);
      -- input, origin: micro
      clk          : IN  std_logic;
      -- inputs, direction: communication => micro
      config_ack   : IN  std_logic;
      reset_ack    : IN  std_logic;
      state        : IN  std_logic_vector(2 DOWNTO 0);
      sync_status  : IN  std_logic;
      frame_rcv    : IN  std_logic_vector(43 DOWNTO 0);
      -- corresponding output
      status_data  : OUT std_logic_vector(49 DOWNTO 0);
      -- inputs, direction: micro => communication
      frame_id     : IN  std_logic_vector(4 DOWNTO 0);
      data_length  : IN  std_logic_vector(4 DOWNTO 0);
      type_of_data : IN  std_logic_vector(1 DOWNTO 0);
      data         : IN  std_logic_vector(31 DOWNTO 0);
      validity_bit : IN  std_logic;
      -- corresponding output
      frame_send   : OUT std_logic_vector(44 DOWNTO 0));
  END COMPONENT;

  COMPONENT pmm IS
    PORT (command               : IN std_logic_vector(1 DOWNTO 0);
          sync_status           : IN std_logic;
          clk, fsm_rst, reg_rst : IN std_logic;

          curr_state : OUT std_logic_vector(2 DOWNTO 0);
          reset_ack  : OUT std_logic;
          wup_en     : OUT std_logic;
          config_ack : OUT std_logic);
  END COMPONENT;

  -- Clock Synchronization Module
  COMPONENT microtick_counter IS
    PORT (
      state            : IN  std_logic_vector(2 DOWNTO 0);
      clk, macro_clock : IN  std_logic;
      global_value     : IN  std_logic_vector(3 DOWNTO 0);  --απαιτούμενα macroticks
                                                            --από διαιτητή
      reset_ff         : IN  std_logic;
      test_output      : OUT std_logic_vector(3 DOWNTO 0);

      -- output frame
      output : OUT std_logic_vector(44 DOWNTO 0);

      --reset signal for the vbit fsm
      rst : IN std_logic;


      -- test signal for the vbit fsm
      fsm_state : OUT std_logic_vector(1 DOWNTO 0)

      );
  END COMPONENT;

  COMPONENT mil_main IS
    PORT (
      clk : IN std_logic;
      rst : IN std_logic := '0';  --θα αλλάξει, γιατί θα ελέγχεται απ' το clock
      --synchronization module

      -- output layer
      chi_out, wupg_out, cs_out : IN  std_logic_vector(44 DOWNTO 0);
      data_out                  : OUT std_logic_vector(54 DOWNTO 0);

      -- input layer
      data_in               : IN  std_logic_vector(54 DOWNTO 0);
      -- το wup_in οδηγεί στον controller host interface
      -- το chi_in είναι για τα δεδομένα
      chi_in, wup_in, cs_in : OUT std_logic_vector(43 DOWNTO 0);

      -- testing
      test_err : OUT std_logic
      );
  END COMPONENT;

  COMPONENT wupr_main IS
    PORT (symbol       : IN  std_logic_vector(3 DOWNTO 0);
          clk, fsm_rst : IN  std_logic;
          wup_found    : OUT std_logic);
  END COMPONENT;

  COMPONENT wupg_main IS
    PORT (
      wupg_en  : IN  std_logic;
      wupg_out : OUT std_logic_vector(44 DOWNTO 0);
      clk      : IN  std_logic;

      sel         : IN  std_logic;
      reset       : IN  std_logic;
      test_output : OUT std_logic
      );
  END COMPONENT;






  -- signals για τη διασύνδεση των components
  -------------------------- CHI -----------------------
  SIGNAL command_out : std_logic_vector(1 DOWNTO 0);
  SIGNAL config_ack  : std_logic;
  SIGNAL reset_ack   : std_logic;
  SIGNAL state       : std_logic_vector(2 DOWNTO 0);
  SIGNAL sync_status : std_logic;
  SIGNAL frame_rcv   : std_logic_vector(43 DOWNTO 0);
  SIGNAL frame_send  : std_logic_vector(44 DOWNTO 0);

  ----------------------- PMM ---------------------------
  SIGNAL fsm_rst : std_logic;           -- external
  SIGNAL reg_rst : std_logic;           -- external
  SIGNAL wup_en  : std_logic;

  ----------------------- CS ----------------------------
  SIGNAL macro_clock  : std_logic;                     -- external
  SIGNAL global_value : std_logic_vector(3 DOWNTO 0);  --external
  SIGNAL reset_ff     : std_logic;                     -- external
  SIGNAL test_output  : std_logic_vector(3 DOWNTO 0);  --external
  SIGNAL output       : std_logic_vector(44 DOWNTO 0);
  SIGNAL rst          : std_logic;                     -- external
  SIGNAL fsm_state    : std_logic_vector(1 DOWNTO 0);  -- external

  ----------------------- MIL ----------------------------
  SIGNAL mil_rst  : std_logic;
  SIGNAL wupg_out : std_logic_vector(44 DOWNTO 0);
  SIGNAL wup_in   : std_logic_vector(43 DOWNTO 0);
  SIGNAL cs_in    : std_logic_vector(43 DOWNTO 0);  -- unused
  SIGNAL test_err : std_logic;                      -- external


  ----------------------- WUPR ----------------------------
  SIGNAL wupr_fsm_rst : std_logic;      -- external
  SIGNAL wup_found    : std_logic;      -- external, προοριζόμενο για το CHI

  ----------------------- WUPG ----------------------------
  SIGNAL sel              : std_logic;  -- external
  SIGNAL reset            : std_logic;  -- external
  SIGNAL wupg_test_output : std_logic;  -- external


  SIGNAL check_validity : std_logic;


BEGIN

  -- έλεγχος εκυρότητας του sync_status
  PROCESS (output)
  BEGIN
    CASE output(0) IS -- το validity bit
      WHEN '1' =>
        sync_status <= output(1); -- τότε ίσο με την έξοδο του clock syncrhonization
      WHEN OTHERS =>
        sync_status <= 'Z';
    END CASE;
  END PROCESS;




  chi0 : chi PORT MAP (command_in => command_in, command_out => command_out, clk => clk, config_ack => config_ack, reset_ack => reset_ack, sync_status => sync_status, state => state, frame_rcv => frame_rcv, status_data => status_data, frame_id => frame_id, data_length => data_length, type_of_data => type_of_data, data => data, validity_bit => validity_bit, frame_send => frame_send);

  pmm0 : pmm PORT MAP (command => command_out, sync_status => sync_status, clk => clk, fsm_rst => fsm_rst, reg_rst => reg_rst, curr_state => state, reset_ack => reset_ack, wup_en => wup_en, config_ack => config_ack);

  cs0 : microtick_counter PORT MAP (state => state, clk => clk, macro_clock => macro_clock, global_value => global_value, reset_ff => reset_ff, test_output => test_output, output => output, rst => rst, fsm_state => fsm_state);

  mil0 : mil_main PORT MAP (clk => mil_clk, rst => mil_rst, chi_out => frame_send, wupg_out => wupg_out, cs_out => output, data_out => data_out, data_in => data_in, chi_in => frame_rcv, wup_in => wup_in, cs_in => cs_in, test_err => test_err);

  wupr0 : wupr_main PORT MAP (symbol => wup_in(4 DOWNTO 1), clk => clk, fsm_rst => wupr_fsm_rst, wup_found => wup_found);

  wupg0 : wupg_main PORT MAP (wupg_en => wup_en, wupg_out => wupg_out, clk => clk, sel => sel, reset => reset, test_output => wupg_test_output);


  -- οδήγηση βοηθητικών σημάτων για το testbench
  -- pmm
  fsm_rst <= ext_fsm_rst;
  reg_rst <= ext_reg_rst;

  -- cs
  macro_clock     <= ext_macro_clock;
  global_value    <= ext_global_value;
  reset_ff        <= ext_reset_ff;
  ext_test_output <= test_output;
  rst             <= ext_rst;
  ext_fsm_state   <= fsm_state;

  -- mil
  ext_test_err <= test_err;
  mil_rst      <= ext_mil_rst;

  -- wupr
  wupr_fsm_rst  <= ext_wupr_fsm_rst;
  ext_wup_found <= wup_found;

  --wupg
  sel                  <= ext_sel;
  reset                <= ext_reset;
  ext_wupg_test_output <= wupg_test_output;
  ext_wupg_output      <= wupg_out;


END default;
