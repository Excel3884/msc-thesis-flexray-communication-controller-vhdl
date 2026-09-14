LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY scheduler IS
  PORT (a, b, c : IN  std_logic;
        s1, s0  : OUT std_logic);

END scheduler;

ARCHITECTURE default OF scheduler IS
  SIGNAL check_null : std_logic;
  SIGNAL input0, input1, input2 : std_logic;
BEGIN
  input0 <= '0' WHEN a = 'Z' ELSE a;
  input1 <= '0' WHEN b = 'Z' ELSE b;
  input2 <= '0' WHEN c = 'Z' ELSE c;

  check_null <= input0 OR input1 OR input2;
  PROCESS(check_null)
  BEGIN
    CASE check_null IS
      WHEN '0' =>
        s1 <= 'Z';
        s0 <= 'Z';
      WHEN OTHERS =>
        s1 <= input0;
        s0 <= input0 OR ((NOT input0) AND (NOT input1) AND input2);
    END CASE;
  END PROCESS;

END default;
