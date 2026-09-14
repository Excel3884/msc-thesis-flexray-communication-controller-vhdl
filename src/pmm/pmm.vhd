LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY pmm IS
  PORT (command               : IN std_logic_vector(1 DOWNTO 0);
        sync_status           : IN std_logic;
        clk, fsm_rst, reg_rst : IN std_logic;

        curr_state : OUT std_logic_vector(2 DOWNTO 0);
        reset_ack  : OUT std_logic;
        wup_en     : OUT std_logic;
        config_ack : OUT std_logic);
END pmm;

ARCHITECTURE pmm_arch OF pmm IS
  COMPONENT dff IS
    GENERIC (d_len : integer := 1;
             q_len : integer := 1);
    PORT (d            : IN  std_logic_vector(d_len-1 DOWNTO 0);
          q            : OUT std_logic_vector(q_len-1 DOWNTO 0);
          clk, rst, en : IN  std_logic);
  END COMPONENT;
  COMPONENT fsm IS
    PORT (command     : IN std_logic_vector(1 DOWNTO 0);
          sync_status : IN std_logic;
          clk, rst    : IN std_logic;

          curr_state : OUT std_logic_vector(2 DOWNTO 0);
          reset_ack  : OUT std_logic;
          wup_en     : OUT std_logic;
          config_ack : OUT std_logic);
  END COMPONENT;

  SIGNAL wire0 : std_logic_vector(2 DOWNTO 0);
BEGIN
  reg0 : dff GENERIC MAP (d_len => 3, q_len => 3) PORT MAP (d(2 DOWNTO 1) => command, d(0) => sync_status, q => wire0, clk => clk, rst => reg_rst, en => '1');

  fsm0 : fsm PORT MAP (command => wire0(2 DOWNTO 1), sync_status => wire0(0), clk => clk, rst => fsm_rst, curr_state => curr_state, reset_ack => reset_ack, wup_en => wup_en, config_ack => config_ack);



END pmm_arch;
