LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY wupg_main IS
  PORT (
    wupg_en  : IN  std_logic;
    wupg_out : OUT std_logic_vector(44 DOWNTO 0);
    clk      : IN  std_logic;

    sel         : IN  std_logic;
    reset       : IN  std_logic;
    test_output : OUT std_logic
    );
END wupg_main;

ARCHITECTURE default OF wupg_main IS

-- components
  COMPONENT srff IS
    PORT (
      set, rst, clk : IN  std_logic;
      q             : OUT std_logic
      );
  END COMPONENT;

  COMPONENT dff IS
    GENERIC (d_len : integer := 1;
             q_len : integer := 1);
    PORT (d            : IN  std_logic_vector(d_len-1 DOWNTO 0);
          q            : OUT std_logic_vector(q_len-1 DOWNTO 0);
          clk, rst, en : IN  std_logic);
  END COMPONENT;

  COMPONENT counter IS
    PORT (
      en, clr, clk : IN  std_logic;
      output       : OUT std_logic_vector(1 DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT rom IS
    PORT (
      addr    : IN  std_logic_vector(1 DOWNTO 0);
      output  : OUT std_logic_vector(4 DOWNTO 0);
      oe, clk : IN  std_logic
      );
  END COMPONENT;

  COMPONENT wupg_mux IS
    PORT (sel  : IN std_logic;
          a, b : IN std_logic;

          output : OUT std_logic);
  END COMPONENT;


-- wires
  SIGNAL ctrl_wire  : std_logic := '0';
  SIGNAL cnt_out    : std_logic_vector(1 DOWNTO 0);
  SIGNAL dff0_out   : std_logic_vector(1 DOWNTO 0);
  SIGNAL rom_out    : std_logic_vector(4 DOWNTO 0);
  SIGNAL dff3_out   : std_logic;
  SIGNAL rst_wire   : std_logic;
  SIGNAL dff2_out   : std_logic_vector(1 DOWNTO 0);
  SIGNAL AND_output : std_logic;
  SIGNAL dff4_out   : std_logic_vector(1 DOWNTO 0);
  SIGNAL dff5_out   : std_logic_vector(1 DOWNTO 0);
  SIGNAL dff1_en    : std_logic;

BEGIN

  srff0 : srff PORT MAP (set => wupg_en, rst => rst_wire, clk => clk, q => ctrl_wire);

  counter0 : counter PORT MAP (en => ctrl_wire, clr => '0', clk => clk, output => cnt_out);

  dff0 : dff GENERIC MAP (d_len => 2, q_len => 2) PORT MAP (d => cnt_out, q => dff0_out, clk => clk, rst => '0', en => ctrl_wire);

  rom0 : rom PORT MAP (addr => dff0_out, output => rom_out, oe => ctrl_wire, clk => clk);

  -- DFF1
  -- εδώ αποστέλεται το σύμβολο μέσα σε ένα πλαίσιο/frame
  -- στο frame id βάζουμε 0, γιατί θα προστεθεί στο medium interface layer
  dff1 : dff GENERIC MAP (d_len => 45, q_len => 45) PORT MAP (d(44 DOWNTO 40) => (OTHERS => '0'), d(39 DOWNTO 35) => "00100", d(34 DOWNTO 33) => "01", d(32 DOWNTO 5) => (OTHERS => '0'), d(4 DOWNTO 0) => rom_out, q => wupg_out, clk => clk, rst => '0', en => dff1_en);

  -- enable signal για το DFF1
  -- rom_out(0) = validity bit
  dff1_en <= dff3_out AND rom_out(0);


  -----------------------------------------

  dff3 : dff GENERIC MAP (d_len => 1, q_len => 1) PORT MAP (d(0) => ctrl_wire, q(0) => dff3_out, clk => clk, rst => '0', en => '1');

  dff2 : dff GENERIC MAP (d_len => 2, q_len => 2) PORT MAP (d => cnt_out, q => dff2_out, clk => clk, rst => reset, en => '1');

  dff4 : dff GENERIC MAP (d_len => 2, q_len => 2) PORT MAP (d => dff2_out, q => dff4_out, clk => clk, rst => reset, en => '1');

  dff5 : dff GENERIC MAP (d_len => 2, q_len => 2) PORT MAP (d => dff4_out, q => dff5_out, clk => clk, rst => reset, en => '1');

  mux0 : wupg_mux PORT MAP (sel => sel, a => '1', b => AND_output, output => rst_wire);

  -- πύλη AND
  AND_output <= dff5_out(1) AND dff5_out(0);

  test_output <= ctrl_wire;

END default;
