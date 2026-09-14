LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY micro_comparator IS
  PORT (local_value  : IN  std_logic_vector(3 DOWNTO 0);  --microticks που μετρήθηκαν
        global_value : IN  std_logic_vector(3 DOWNTO 0);  -- απαιτούμενα microticks από διαιτητή
        en, clk      : IN  std_logic;
        sync_status  : OUT std_logic);
END micro_comparator;

ARCHITECTURE default OF micro_comparator IS
BEGIN
  PROCESS (clk)
  BEGIN
    CASE en IS
      WHEN '1' =>
        IF (clk'event AND clk = '1') THEN
          IF (global_value = local_value) THEN
            sync_status <= '1';
          ELSE
            sync_status <= '0';
          END IF;
        END IF;
      WHEN OTHERS =>
        sync_status <= 'Z';
    END CASE;
  END PROCESS;
END default;


