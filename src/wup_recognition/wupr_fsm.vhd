LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY wupr_fsm IS
  PORT (symbol   : IN std_logic_vector(3 DOWNTO 0);
        clk, rst : IN std_logic;

        wup_found : OUT std_logic;

        --testing signal
        curr_state : OUT std_logic_vector(2 DOWNTO 0));

END wupr_fsm;

-- η αρχιτεκτονική βασίζεται στο στυλ σχεδιασμού #2 απ'το βιβλίο του Pedroni
ARCHITECTURE default OF wupr_fsm IS
  TYPE states IS (m0, m1, m2, m3, m4);
  SIGNAL prv_state, nxt_state : states;
  SIGNAL temp_wup_found       : std_logic;
BEGIN

  PROCESS (clk, rst)
  BEGIN
    IF (rst = '1') THEN
      prv_state  <= m0;
      curr_state <= std_logic_vector(to_unsigned(states'pos(m0), 3));
      wup_found <= '0';
    ELSIF (clk'event AND clk = '1') THEN
      wup_found  <= temp_wup_found;
      prv_state  <= nxt_state;
      curr_state <= std_logic_vector(TO_unsigned(states'pos(nxt_state), 3));
    END IF;
  END PROCESS;

  PROCESS (prv_state, symbol)
  BEGIN
    CASE prv_state IS

      WHEN m0 =>
        CASE symbol IS
          WHEN "1010" =>
            temp_wup_found <= '0';
            nxt_state <= m1;
          WHEN OTHERS =>
            temp_wup_found <= '0';
        END CASE;

      WHEN m1 =>
        CASE symbol IS
          WHEN "1111" =>
            nxt_state <= m2;
          WHEN OTHERS =>
            nxt_state <= m0;
        END CASE;

      WHEN m2 =>
        CASE symbol IS
          WHEN "0010" =>
            nxt_state <= m3;
          WHEN OTHERS =>
            nxt_state <= m0;
        END CASE;

      WHEN m3 =>
        CASE symbol IS
          WHEN "0111" =>
            nxt_state      <= m4;
            temp_wup_found <= '1';
          WHEN OTHERS =>
            nxt_state <= m0;
        END CASE;

      WHEN m4 =>
        nxt_state      <= m0;
        temp_wup_found <= '0';

      WHEN OTHERS =>
        NULL;

    END CASE;
  END PROCESS;



END default;
