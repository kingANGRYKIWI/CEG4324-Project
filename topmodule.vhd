----------------------------------------------------------------------------------
-- Company:
-- Engineer: Instructor
--
-- Create Date: 
-- Design Name:
-- Module Name: topmodule - Behavioral
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.oled_pkg.all;
use work.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity topmodule is
    Port ( clk         : in std_logic;
           rst         : in std_logic;
           oled_sdin   : out std_logic;
           oled_sclk   : out std_logic;
           oled_dc     : out std_logic;
           oled_res    : out std_logic;
           oled_vbat   : out std_logic;
           oled_vdd    : out std_logic;
           N : in STD_LOGIC;
           S : in STD_LOGIC;
           E : in STD_LOGIC;
           W : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR (7 downto 0);
           LED : out STD_LOGIC_VECTOR (7 downto 0));
end topmodule;

architecture Behavioral of topmodule is

component oled_ctrl is
    port (  clk         : in std_logic;
            rst         : in std_logic;
            hi          : in std_logic;
            oled_sdin   : out std_logic;
            oled_sclk   : out std_logic;
            oled_dc     : out std_logic;
            oled_res    : out std_logic;
            oled_vbat   : out std_logic;
            oled_vdd    : out std_logic;
            data        : in oled_mem);
end component;


component pipelined_adder
    generic(N :integer := 12); --4 bit pipelined adder is given here (change accordingly for 6 bit)
    Port   (A  : in STD_LOGIC_VECTOR (N-1 downto 0);
            B  : in STD_LOGIC_VECTOR (N-1 downto 0);
            Ci : in STD_LOGIC;
            S  : out STD_LOGIC_VECTOR (N downto 0);
            CLK, RSTn : in STD_LOGIC );
end component;

signal oled_sdin_s,oled_sclk_s,oled_dc_s,oled_res_s,oled_vbat_s,oled_vdd_s : std_logic;


SIGNAL Aval,Bval : STD_LOGIC_VECTOR(11 DOWNTO 0):="000000000000";
SIGNAL Rval : STD_LOGIC_VECTOR(12 DOWNTO 0):="0000000000000";
SIGNAL data,Ldata : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL A,B,MSB,LSB,R,forA,forB,forR: STD_LOGIC:= '0';
SIGNAL Co : STD_LOGIC;
SIGNAL dataA, dataB : add_pkg;
SIGNAL dataS : sum_pkg;
SIGNAL three : STD_LOGIC_VECTOR(3 downto 0):="0011";
SIGNAL four : STD_LOGIC_VECTOR(3 downto 0):="0100";

constant data_val : oled_mem := ( (x"20", x"20", x"38", x"2D", x"62", x"69", x"74", x"20", x"41", x"44", x"44", x"45", x"52", x"20", x"20", x"20"),
                                  (x"20", x"41", x"20", x"20", x"2B", x"20", x"20", x"42", x"20", x"3D", x"20", x"53", x"55", x"4D", x"20", x"20"),
                                  (x"20", x"20", dataA(1), dataA(0), x"2B", x"20", x"20", dataB(1), dataB(0), x"3D", x"20", dataS(2), dataS(1), dataS(0), x"20", x"20"),
                                  (x"20", x"20", x"20", x"20", x"20", x"20", x"3B", x"2D", x"29", x"20", x"20", x"20", x"20", x"20", x"20", x"20"));


begin

oled_sdin<=oled_sdin_s;
oled_sclk<=oled_sclk_s;
oled_dc<=oled_dc_s;
oled_res<=oled_res_s;
oled_vbat<=oled_vbat_s;
oled_vdd<=oled_vdd_s;


data(7)<=SW(7);
data(6)<=SW(6);
data(5)<=SW(5);
data(4)<=SW(4);
data(3)<=SW(3);
data(2)<=SW(2);
data(1)<=SW(1);
data(0)<=SW(0);

LED(7)<=Ldata(7);
LED(6)<=Ldata(6);
LED(5)<=Ldata(5);
LED(4)<=Ldata(4);
LED(3)<=Ldata(3);
LED(2)<=Ldata(2);
LED(1)<=Ldata(1);
LED(0)<=Ldata(0);

A<=N;
B<=S;
MSB<=W;
LSB<=E;


 Comp_th: oled_ctrl port map (  clk,
                                rst,
                                W,
                                oled_sdin_s,
                                oled_sclk_s,
                                oled_dc_s,
                                oled_res_s,
                                oled_vbat_s,
                                oled_vdd_s,
                                data_val);


comp_ADD:  pipelined_adder
           generic map(N=>12)
           port map (A=>Aval,B=>Bval,Ci=>'0',S=>Rval,CLK=>clk,RSTn=>rst);

process(clk, A, B, R)
    begin
        if(rising_edge(clk)) then
            if(A = '1') then
                Aval<=data;
                Ldata<=Aval;
            end if;
            if(B = '1') then
                Bval<=data;
                Ldata<=Bval;
            end if;     
        end if;
end process;




process(clk)
    begin
        if(rising_edge(clk)) then
--          A

    if(Aval(11 downto 8)>"1001") then
                dataA(2)<= four & ( Aval(11 downto 8) - "1001");
            else
                dataA(2)<= three & Aval(11 downto 8);
            end if;
            
            if(Aval(7 downto 4)>"1001") then
                dataA(1)<= four & ( Aval(7 downto 4) - "1001");
            else
                dataA(1)<= three & Aval(7 downto 4);
            end if;
--             dataA(1)<= three & Aval(7 downto 4);
            if(Aval(3 downto 0)>"1001") then
                dataA(0)<= four & ( Aval(3 downto 0) - "1001");
            else
                dataA(0)<= three & Aval(3 downto 0);
            end if;


--          B  

     if(Bval(11 downto 8)>"1001") then
                dataB(2)<= four & (Bval(11 downto 8) - "1001");
            else
                dataB(2)<= three & Bval(11 downto 8);
            end if;
            if(Bval(7 downto 4)>"1001") then
                dataB(1)<= four & (Bval(7 downto 4) - "1001");
            else
                dataB(1)<= three & Bval(7 downto 4);
            end if;
--            dataB(1)<= three & Bval(7 downto 4);
            if(Bval(3 downto 0)>"1001") then
                dataB(0)<= four & (Bval(3 downto 0) - "1001");
            else
                dataB(0)<= three & Bval(3 downto 0);
            end if;

--          SUM
            dataS(2)<= three & "000" & Rval(12);
            
            if(Rval(11 downto 8)>"1001") then
                dataS(2)<= four & ( Rval(11 downto 8) - "1001");
            else
                dataS(2)<= three & Rval(11 downto 8);
            end if;
            
            if(Rval(7 downto 4)>"1001") then
                dataS(1)<= four & ( Rval(7 downto 4) - "1001");
            else
                dataS(1)<= three & Rval(7 downto 4);
            end if;
--            dataS(1)<= three & '0' & Rval(6 downto 4);
            if(Rval(3 downto 0)>"1001") then
                dataS(0)<= four & ( Rval(3 downto 0) - "1001");
            else
                dataS(0)<= three & Rval(3 downto 0);
            end if;


        end if;
end process;

end Behavioral;
