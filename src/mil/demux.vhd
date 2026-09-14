LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY demux IS
  PORT (sel   : IN std_logic_vector(1 DOWNTO 0);
        input : IN std_logic_vector(43 DOWNTO 0);

        a, b, c : OUT std_logic_vector(43 DOWNTO 0));
END demux;

ARCHITECTURE default OF demux IS
BEGIN

  PROCESS(sel)
  BEGIN
    CASE sel IS
      WHEN "00" =>
        a <= input;
        b <= (OTHERS => 'Z');
        c <= (OTHERS => 'Z');
      WHEN "01" =>
        a <= (OTHERS => 'Z');
        b <= input;
        c <= (OTHERS => 'Z');
      WHEN "10" =>
        a <= (OTHERS => 'Z');
        b <= (OTHERS => 'Z');
        c <= input;
      WHEN OTHERS =>
        a <= (OTHERS => 'Z');
        b <= (OTHERS => 'Z');
        c <= (OTHERS => 'Z');

    END CASE;
  END PROCESS;

END default;
