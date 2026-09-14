LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux IS
  PORT (sel     : IN std_logic_vector(1 DOWNTO 0);
        a, b, c : IN std_logic_vector(44 DOWNTO 0);

        output : OUT std_logic_vector(44 DOWNTO 0));
END mux;

ARCHITECTURE default OF mux IS
BEGIN

  WITH sel SELECT
    output <= a     WHEN "00",
    b WHEN "01",
    c WHEN "11", -- τροποποιήθηκε σε "11", για να είναι συμβατό με τον πολυπλέκτη
    (OTHERS => 'Z') WHEN OTHERS;



END default;

