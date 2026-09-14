LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE tb OF testbench IS
  SIGNAL a, b, c, s1, s0 : std_logic;
  SIGNAL counter         : std_logic_vector(2 DOWNTO 0) := "000";  -- counter for loop
BEGIN

    scheduler0: entity work.scheduler port map (a=>a, b=>b, c=>c, s1=>s1, s0=>s0);

  PROCESS
  BEGIN
    FOR i IN 0 TO 7 LOOP
      a       <= counter(2);
      b       <= counter(1);
      c       <= counter(0);
      counter <= std_logic_vector(unsigned(counter) + 1);
      WAIT FOR 10 ns;
    END LOOP;
  END PROCESS;

END tb;



