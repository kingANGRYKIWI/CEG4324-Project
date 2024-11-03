----------------------------------------------------------------------------------
---REGISTER
library ieee;
use ieee.std_logic_1164.all;

entity REG is
    port(D, CLK, RSTn: in std_logic;
         Q: out std_logic);
end entity;

architecture behaviour of REG is

begin

process(CLK)
    begin
        if (rising_edge(CLK)) then
            if(RSTn = '1') then
                Q <= '0'
                  --pragma_sythesis_off
                  after 10ns
                  --pragma_sythesis_on
                  ;
               else
                Q <= D
                  --pragma_sythesis_off
                  after 10ns
                  --pragma_sythesis_on
                  ;
            end if;
        end if;
    end process;

end architecture;

----------------------------------------------------------------------------------
---FULL ADDER
library ieee;
use ieee.std_logic_1164.all;

entity FA is
    port (A, B, Ci: IN STD_LOGIC ;
          S, Co: OUT STD_LOGIC ) ;
end entity;

architecture behaviour of FA is
    begin
        S  <= A XOR B XOR Ci
        --pragma_sythesis_off
        after 10ns
        --pragma_sythesis_on
        ;
        Co <= (A AND B) OR (Ci AND A) OR (Ci AND B)
        --pragma_sythesis_off
        after 15ns
        --pragma_sythesis_on
        ;
end architecture;

----------------------------------------------------------------------------------
---PIPELINED ADDER
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pipelined_adder is
    generic(N :integer := 12); --4 bit pipelined adder is given here as an example
    Port   (A  : in STD_LOGIC_VECTOR (N-1 downto 0);
            B  : in STD_LOGIC_VECTOR (N-1 downto 0);
            Ci : in STD_LOGIC;
            S  : out STD_LOGIC_VECTOR (N downto 0);
            CLK, RSTn : in STD_LOGIC );
end pipelined_adder;

architecture Behavioral of pipelined_adder is

--- component declaration

component FA
    PORT (A, B, Ci: IN STD_LOGIC ;
          S, Co: OUT STD_LOGIC ) ;
end component;

component REG
    port(D, CLK, RSTn: in std_logic;
         Q: out std_logic);
end component;

--- signal declaration example is given below.
--- You'll need to modify signals and their vector sizes for your pipeline designs

signal Co       : std_logic;    --use this signal as your last carry out signal

signal tmp_cout : std_logic_vector(12 downto 0);

signal tmp_S0   : std_logic_vector(1 downto 0);
signal tmp_S1   : std_logic_vector(1 downto 0);
signal tmp_S2   : std_logic_vector(1 downto 0);
signal tmp_S3   : std_logic_vector(1 downto 0);
signal tmp_S4   : std_logic_vector(1 downto 0);
signal tmp_S5   : std_logic_vector(1 downto 0);
signal tmp_S6   : std_logic;
signal tmp_S7   : std_logic;
signal tmp_S8   : std_logic;
signal tmp_S9   : std_logic;
signal tmp_S10   : std_logic;
signal tmp_S11   : std_logic;


signal tmp_A6 : std_logic;
signal tmp_B6 : std_logic;
signal tmp_A7 : std_logic;
signal tmp_B7 : std_logic;
signal tmp_A8 : std_logic;
signal tmp_B8 : std_logic;
signal tmp_A9 : std_logic;
signal tmp_B9 : std_logic;
signal tmp_A10 : std_logic;
signal tmp_B10 : std_logic;
signal tmp_A11 : std_logic;
signal tmp_B11 : std_logic;


--- add necessary signals here

begin

--- 1st Full Adder

FA_0    : FA port map(A(0), B(0), Ci, tmp_S0(0), tmp_cout(0));

reg_s0_0: REG port map(tmp_S0(0), CLK, RSTn, tmp_S0(1));
reg_s0_1: REG port map(tmp_S0(1), CLK, RSTn, S(0));

--- 2nd Full Adder

FA_1    : FA port map(A(1), B(1), tmp_cout(0), tmp_S1(0), tmp_cout(1));

reg_s1_0: REG port map(tmp_S1(0), CLK, RSTn, tmp_S1(1));
reg_s1_1: REG port map(tmp_S1(1), CLK, RSTn, S(1));

---3rd Full Adder

FA_2: FA port map(A(2), B(2), tmp_cout(1), tmp_S2(0), tmp_cout(2));

reg_s2_0: REG port map(tmp_S2(0), CLK, RSTn, tmp_S2(1));
reg_s2_1: REG port map(tmp_S2(1), CLK, RSTn, S(2));

--- 4th Full Adder

FA_3: FA port map(A(3), B(3), tmp_cout(2), tmp_S3(0), tmp_cout(3));

reg_s3_0: REG port map(tmp_S3(0), CLK, RSTn, tmp_S3(1));
reg_s3_1: REG port map(tmp_S3(1), CLK, RSTn, S(3));

--- 5th Full Adder

FA_4: FA port map(A(4), B(4), tmp_cout(3), tmp_S4(0), tmp_cout(4));

reg_s4_0: REG port map(tmp_S4(0), CLK, RSTn, tmp_S4(1));
reg_s4_1: REG port map(tmp_S4(1), CLK, RSTn, S(4));

--- 6th Full Adder

FA_5: FA port map(A(5), B(5), tmp_cout(4), tmp_S5(0), tmp_cout(5));

reg_s5_0: REG port map(tmp_S5(0), CLK, RSTn, tmp_S5(1));
reg_s5_1: REG port map(tmp_S5(1), CLK, RSTn, S(5));

cout_reg_0: REG port map(tmp_cout(5), CLK, RSTn, tmp_cout(6));

--- 7th Full Adder

reg_tmp_A6: REG port map(A(6), CLK, RSTn, tmp_A6);
reg_tmp_B6: REG port map(B(6), CLK, RSTn, tmp_B6);

FA_6: FA port map(tmp_A6, tmp_B6, tmp_cout(6), tmp_S6, tmp_cout(7));

reg_s6: REG port map(tmp_S6, CLK, RSTn, S(6));

--- 8th Full Adder

reg_tmp_A7: REG port map(A(7), CLK, RSTn, tmp_A7);
reg_tmp_B7: REG port map(B(7), CLK, RSTn, tmp_B7);

FA_7: FA port map(tmp_A7, tmp_B7, tmp_cout(7), tmp_S7, tmp_cout(8));

reg_s7: REG port map(tmp_S7, CLK, RSTn, S(7));

--- 9th Full Adder

reg_tmp_A8: REG port map(A(8), CLK, RSTn, tmp_A8);
reg_tmp_B8: REG port map(B(8), CLK, RSTn, tmp_B8);

FA_8: FA port map(tmp_A8, tmp_B8, tmp_cout(8), tmp_S8, tmp_cout(9));

reg_s8: REG port map(tmp_S8, CLK, RSTn, S(8));

--- 10th Full Adder

reg_tmp_A9: REG port map(A(9), CLK, RSTn, tmp_A9);
reg_tmp_B9: REG port map(B(9), CLK, RSTn, tmp_B9);

FA_9: FA port map(tmp_A9, tmp_B9, tmp_cout(9), tmp_S9, tmp_cout(10));

reg_s9: REG port map(tmp_S9, CLK, RSTn, S(9));

--- 11th Full Adder

reg_tmp_A10: REG port map(A(10), CLK, RSTn, tmp_A10);
reg_tmp_B10: REG port map(B(10), CLK, RSTn, tmp_B10);

FA_10: FA port map(tmp_A10, tmp_B10, tmp_cout(10), tmp_S10, tmp_cout(11));

reg_s10: REG port map(tmp_S10, CLK, RSTn, S(10));

--- 12th Full Adder

reg_tmp_A11: REG port map(A(11), CLK, RSTn, tmp_A11);
reg_tmp_B11: REG port map(B(11), CLK, RSTn, tmp_B11);

FA_11: FA port map(tmp_A11, tmp_B11, tmp_cout(11), tmp_S11, tmp_cout(12));

reg_s11: REG port map(tmp_S11, CLK, RSTn, S(11));

cout_reg_1: REG port map(tmp_cout(12), CLK, RSTn, Co);

S(N)<=Co;

end Behavioral;
