LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.encoding.ALL;

ENTITY encoder IS
  PORT (input   : IN  std_logic_vector(43 DOWNTO 0);
        en, clk : IN  std_logic;
        output  : OUT std_logic_vector(54 DOWNTO 0) := (OTHERS => 'Z'));

END encoder;

ARCHITECTURE default OF encoder IS
BEGIN
  PROCESS (clk)
  BEGIN
    CASE en IS
      WHEN '1' =>
        IF (clk'event AND clk = '1') THEN
          encode(input(43 DOWNTO 40), output(54 DOWNTO 50));
          encode(input(39 DOWNTO 36), output(49 DOWNTO 45));
          encode(input(35 DOWNTO 32), output(44 DOWNTO 40));
          encode(input(31 DOWNTO 28), output(39 DOWNTO 35));
          encode(input(27 DOWNTO 24), output(34 DOWNTO 30));
          encode(input(23 DOWNTO 20), output(29 DOWNTO 25));
          encode(input(19 DOWNTO 16), output(24 DOWNTO 20));
          encode(input(15 DOWNTO 12), output(19 DOWNTO 15));
          encode(input(11 DOWNTO 8), output(14 DOWNTO 10));
          encode(input(7 DOWNTO 4), output(9 DOWNTO 5));
          encode(input(3 DOWNTO 0), output(4 DOWNTO 0));
        END IF;
      WHEN OTHERS =>
        output <= (OTHERS => 'Z');
    END CASE;
  END PROCESS;

END default;


