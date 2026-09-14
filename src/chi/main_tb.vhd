LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE tb OF testbench IS
  SIGNAL command_in  : std_logic_vector(1 DOWNTO 0);
  SIGNAL command_out : std_logic_vector(1 DOWNTO 0);

  SIGNAL clk : std_logic := '0';

  SIGNAL config_ack, reset_ack, sync_status : std_logic;
  SIGNAL state                              : std_logic_vector(2 DOWNTO 0);
  SIGNAL frame_rcv                          : std_logic_vector(43 DOWNTO 0);

  SIGNAL status_data : std_logic_vector(49 DOWNTO 0);

  SIGNAL frame_id, data_length : std_logic_vector(4 DOWNTO 0);
  SIGNAL type_of_data          : std_logic_vector(1 DOWNTO 0);
  SIGNAL data                  : std_logic_vector(31 DOWNTO 0);
  SIGNAL validity_bit          : std_logic;

  SIGNAL frame_send : std_logic_vector(44 DOWNTO 0);

BEGIN
  interface : ENTITY work.chi PORT MAP (command_in => command_in, command_out => command_out, clk => clk, config_ack => config_ack, reset_ack => reset_ack, sync_status => sync_status, state => state, frame_rcv => frame_rcv, status_data => status_data, frame_id => frame_id, data_length => data_length, type_of_data => type_of_data, data => data, validity_bit => validity_bit, frame_send => frame_send);


  clk <= NOT clk AFTER 10 ns;

  PROCESS
  BEGIN
    -- reg0
    command_in   <= "10";
    WAIT FOR 25 ns;
    -- reg1
    config_ack   <= '1';
    reset_ack    <= '0';
    state        <= "110";
    sync_status  <= '1';
    frame_rcv    <= (7      => '0', OTHERS => '1');
    WAIT FOR 25 ns;
    -- reg2
    frame_id     <= (OTHERS => '1');
    data_length  <= (OTHERS => '1');
    type_of_data <= (OTHERS => '1');
    data         <= (OTHERS => '1');
    validity_bit <= '0';
    WAIT FOR 25 ns;

  END PROCESS;


END tb;
