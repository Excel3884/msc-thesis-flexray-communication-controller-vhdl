LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY wupg_mux IS
  PORT (sel  : IN std_logic;
        a, b : IN std_logic;

        output : OUT std_logic);
END wupg_mux;

ARCHITECTURE default OF wupg_mux IS
BEGIN

  WITH sel SELECT
    output <= a WHEN '0',
    b WHEN '1',
    'Z'         WHEN OTHERS;



END default;
