LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY rom IS
  PORT (
    addr    : IN  std_logic_vector(1 DOWNTO 0);
    output  : OUT std_logic_vector(4 DOWNTO 0);
    oe, clk : IN  std_logic
    );
END rom;

ARCHITECTURE default OF rom IS
  TYPE memory4 IS ARRAY (0 TO 3) OF std_logic_vector(4 DOWNTO 0);
  -- τα 3 πρώτα bits αναπαριστούν το σύμβολο και το τελευταίο bit είναι το validity bit
  CONSTANT rom4 : memory4 := (
    "10101", "11111", "00101", "01111"
    );
BEGIN
  PROCESS(clk)
  BEGIN
    CASE oe IS
      WHEN '1' =>
        CASE addr IS
          WHEN (OTHERS => 'Z') =>
            output <= (OTHERS => 'Z');
          WHEN OTHERS =>
            IF (clk'event AND clk = '1') THEN
              output <= rom4(to_integer(unsigned(addr)));
            END IF;
        END CASE;
      WHEN OTHERS =>
        output <= (OTHERS => 'Z');
    END CASE;
  END PROCESS;
END default;
