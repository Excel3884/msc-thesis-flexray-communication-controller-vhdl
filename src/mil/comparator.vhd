LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.encoding.ALL;

ENTITY comparator IS
  PORT (input       : IN  std_logic_vector(4 DOWNTO 0);
        output      : OUT std_logic_vector(4 DOWNTO 0);
        en, clk     : IN  std_logic;
        found_error : OUT std_logic);
END comparator;

ARCHITECTURE default OF comparator IS
BEGIN
  PROCESS (clk)
  BEGIN
    CASE en IS
      WHEN '1' =>
        IF (clk'event AND clk = '1') THEN
          check(input, output, found_error);
        END IF;
      WHEN OTHERS =>
        output      <= (OTHERS => 'Z');
        found_error <= 'Z';
    END CASE;
  END PROCESS;
END default;
