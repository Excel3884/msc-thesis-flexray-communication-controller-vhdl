LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY op_mux IS
  PORT (sel    : IN  std_logic;
        a, b   : IN  std_logic_vector(1 DOWNTO 0);
        output : OUT std_logic_vector(1 DOWNTO 0));
END op_mux;

ARCHITECTURE default OF op_mux IS
BEGIN


  WITH sel SELECT
    output <= a     WHEN '0',
    b WHEN '1',
    (OTHERS => 'Z') WHEN OTHERS;

END default;
