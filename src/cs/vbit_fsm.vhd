LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY vbit_fsm IS
  PORT (
    buffer_inv   : IN  std_logic;
    validity_bit : OUT std_logic;

    clk, rst : IN std_logic;

    --testing signal
    curr_state : OUT std_logic_vector(1 DOWNTO 0)
    );
END vbit_fsm;

-- η αρχιτεκτονική βασίζεται στο στυλ σχεδιασμού #1 απ'το βιβλίο του Pedroni
-- (ασύγχρονη έξοδος)

ARCHITECTURE default OF vbit_fsm IS
  TYPE states IS (m0, m1, m2, m3, m4);
  SIGNAL prv_state, nxt_state : states;
BEGIN

  PROCESS (clk, rst)
  BEGIN
    IF (rst = '1') THEN
      prv_state  <= m0;
      curr_state <= std_logic_vector(to_unsigned(states'pos(m0), 2));
    ELSIF (clk'event AND clk = '1') THEN
      prv_state  <= nxt_state;
      curr_state <= std_logic_vector(to_unsigned(states'pos(nxt_state), 2));
    END IF;
  END PROCESS;

  PROCESS (prv_state, buffer_inv)
  BEGIN
    CASE prv_state IS
      WHEN m0 =>
        validity_bit <= '0';
        CASE buffer_inv IS
          WHEN '0' =>
            nxt_state <= m1;
          WHEN OTHERS =>
            NULL;
        END CASE;
      WHEN m1 =>
        CASE buffer_inv IS
          WHEN '1' =>
            nxt_state <= m2;
          WHEN OTHERS =>
            NULL;
        END CASE;
      WHEN m2 =>                        -- wait state
        nxt_state <= m3;
      WHEN m3 =>
        validity_bit <= '1';
        nxt_state    <= m4;
      WHEN m4 =>
        validity_bit <= '0';
        CASE buffer_inv IS
          WHEN '0' =>
            nxt_state <= m1;
          WHEN OTHERS =>
            NULL;
        END CASE;
      WHEN OTHERS =>
        NULL;
    END CASE;
  END PROCESS;

END default;



