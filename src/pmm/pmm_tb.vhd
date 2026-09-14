LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY pmm_testbench IS
END pmm_testbench;

ARCHITECTURE pmm_tb OF pmm_testbench IS
  SIGNAL command          : std_logic_vector(1 DOWNTO 0);
  SIGNAL sync_status      : std_logic;
  SIGNAL fsm_rst, reg_rst : std_logic;
  SIGNAL clk              : std_logic := '0';

  SIGNAL curr_state : std_logic_vector(2 DOWNTO 0);
  SIGNAL reset_ack  : std_logic;
  SIGNAL wup_en     : std_logic;
  SIGNAL config_ack : std_logic;
BEGIN
  pmm : ENTITY work.pmm PORT MAP (command => command, sync_status => sync_status, clk => clk, fsm_rst => fsm_rst, reg_rst => reg_rst, curr_state => curr_state, reset_ack => reset_ack, wup_en => wup_en, config_ack => config_ack);

  clk     <= NOT clk AFTER 10 ns;
  reg_rst <= '0';


  PROCESS
  BEGIN
    sync_status <= '0';
    fsm_rst         <= '1';
    WAIT FOR 25 ns;

    fsm_rst <= '0';
    command <= "10";
    WAIT FOR 80 ns;


  END PROCESS;





END pmm_tb;
