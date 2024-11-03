----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:
-- Design Name:
-- Module Name: tb_pipelined_adder - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_pipelined_adder is
    generic(N :integer := 12); --4 bit pipelined adder is given here as an example
--  Port ( );
end tb_pipelined_adder;

architecture Behavioral of tb_pipelined_adder is
component pipelined_adder is
    generic(N :integer := 12); --4 bit pipelined adder (change accordingly)
    Port ( A  : in STD_LOGIC_VECTOR (N-1 downto 0);
           B  : in STD_LOGIC_VECTOR (N-1 downto 0);
           Ci : in STD_LOGIC;
           S  : out STD_LOGIC_VECTOR (N downto 0);
--           Co : out STD_LOGIC;
           CLK, RSTn : in STD_LOGIC );
end component;

   signal A,B : std_logic_vector (N-1 downto 0);
   signal Ci  : std_logic := '0';
   signal clk : std_logic := '0';
   signal rst : std_logic := '1';
   signal Sum : std_logic_vector (N downto 0);
--   signal Co  : std_logic;

constant clk_period : time := 70 ns;     -- Clock Frequency

constant  P: integer:= 3;                -- number of pipeline stages

begin

UTT: pipelined_adder generic map(N=>12) port map(A,B,Ci,Sum,clk,rst); --4 bit pipelined adder (change accordingly)

clk_process :process
                  begin
                      clk <= '0';
                      wait for clk_period/2;
                      clk <= '1';
                  wait for clk_period/2;
              end process;

stim_proc: process
              begin

-------------12-bit ADDER INPUTS are given here as an example
                    rst <= '1';
                    A <= "000000000000"; 
                    B <= "000000000000"; 
                    Ci<= '0';
                    wait for clk_period;

                    rst <= '0';         --- 27+127
                    A <= "000000011011"; 
                    B <= "000001111111"; 
                    Ci<= '0';
                    wait for (P)*clk_period;

                    A <= "000000011011"; -- 27+127+1
                    B <= "000001111111"; 
                    Ci<= '1';
                    wait for (P)*clk_period;
                
                    A <= "000000011011"; -- 27+4095
                    B <= "111111111111"; 
                    Ci<= '0';
                    wait for (P)*clk_period;
                
                    A <= "000000011011"; -- 27+4095+1
                    B <= "111111111111"; 
                    Ci<= '1';
                    wait for (P)*clk_period;
                    
                    A <= "000001110101"; --117+127
                    B <= "000001111111"; 
                    Ci<= '0';
                    wait for (P)*clk_period;
                
                    A <= "000001110101"; --117+127+1 
                    B <= "000001111111"; 
                    Ci<= '1';
                    wait for (P)*clk_period;

                    A <= "000001110101"; --117+4095
                    B <= "111111111111"; 
                    Ci<= '0';
                    wait for (P)*clk_period;

                    A <= "000001110101"; --117+4095+1
                    B <= "111111111111"; 
                    Ci<= '1';
                    wait for (P)*clk_period;
                
                std.env.finish;
---------------------------4-bit ADDER INPUT-------------------------------
            end process;



end Behavioral;
