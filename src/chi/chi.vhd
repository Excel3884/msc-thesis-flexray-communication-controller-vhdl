LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY chi IS
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
END chi;

ARCHITECTURE chi_interface OF chi IS
  COMPONENT dff IS
    GENERIC (d_len : integer := 1;
             q_len : integer := 1);
    PORT (d            : IN  std_logic_vector(d_len-1 DOWNTO 0);
          q            : OUT std_logic_vector(q_len-1 DOWNTO 0);
          clk, rst, en : IN  std_logic);
  END COMPONENT;
  
  signal temp : std_logic_vector(4 downto 0);
BEGIN
  temp <= config_ack & reset_ack & state;  

  reg0 : dff GENERIC MAP (d_len => 2, q_len => 2) PORT MAP (d => command_in, q => command_out, clk => clk, rst => '0', en => '1');

  reg1 : dff GENERIC MAP (d_len => 50, q_len => 50) PORT MAP (d(49 DOWNTO 45) => temp, d(44) => sync_status, d(43 DOWNTO 0) => frame_rcv, q => status_data, clk => clk, rst => '0', en => '1');

  reg2 : dff GENERIC MAP (d_len => 45, q_len => 45) PORT MAP (d(44 DOWNTO 40) => frame_id, d(39 DOWNTO 35) => data_length, d(34 DOWNTO 33) => type_of_data, d(32 DOWNTO 1) => data, d(0) => validity_bit, q => frame_send, clk => clk, rst => '0', en => '1');

END chi_interface;
