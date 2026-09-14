LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE tb OF testbench IS
  -- input layer
  SIGNAL chi_out, wupg_out, cs_out : std_logic_vector(44 DOWNTO 0);
  SIGNAL clk                       : std_logic := '0';
  SIGNAL rst                       : std_logic;
  SIGNAL data_out                  : std_logic_vector(54 DOWNTO 0);

  -- output layer
  SIGNAL data_in               : std_logic_vector(54 DOWNTO 0);
  SIGNAL chi_in, wup_in, cs_in : std_logic_vector(43 DOWNTO 0);

  -- testing
  SIGNAL test_err : std_logic;
BEGIN

  mil : ENTITY work.mil_main PORT MAP (chi_out => chi_out, wupg_out => wupg_out, cs_out => cs_out, clk => clk, rst => rst, data_out => data_out, data_in => data_in, chi_in => chi_in, wup_in => wup_in, cs_in => cs_in, test_err => test_err);

  clk <= NOT clk AFTER 10 ns;
  rst <= '0';




    -- output layer testing
    chi_out  <= (0  => '1', 1 => '1', OTHERS => '0');
    wupg_out <= (44 => '1', 0 => '1', OTHERS => '0');
    cs_out   <= (2  => '1', OTHERS => '0');

    -- input layer testing
    --data_in <= ("1001010010100111001010010110101101011010110101101010010");
    data_in <= ("1111110010100111001010010110101101011010110101101010010");

  --αλλαξε την πρωτη 5αδα σε "11111"για error





END tb;
