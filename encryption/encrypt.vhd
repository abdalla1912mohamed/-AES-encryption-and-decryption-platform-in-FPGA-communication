----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:15:31 12/11/2019 
-- Design Name: 
-- Module Name:    encrypt - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
package MultiDimentionalArray is
  type matrix is array(0 to 3, 0 to 3) of integer range 0 to 255;
  type table is array(0 to 15, 0 to 15) of integer range 0 to 255;
  type table2 is array(0 to 3, 0 to 9) of integer range 0 to 255;
end MultiDimentionalArray;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.MultiDimentionalArray.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity encrypt is
Port(output: out std_logic_vector(7 downto 0);
	  switch: in std_logic);
end encrypt;

architecture Behavioral of encrypt is
signal output_signal:std_logic_vector(7 downto 0);
signal s_box_substitution: table;
signal Rcon: table2;
signal key: matrix;
--initializing the tables needed in MixCloumns step
		signal mul2: table :=(
		(0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30),
		(32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62),
		(64,66,68,70,72,74,76,78,80,82,84,86,88,90,92,94),
		(96,98,100,102,104,106,108,110,112,114,116,118,120,122,124,126),
		(128,130,132,134,136,138,140,142,144,146,148,150,152,154,156,158),
		(160,162,164,166,168,170,172,174,176,178,180,182,184,186,188,190),
		(192,194,196,198,200,202,204,206,208,210,212,214,216,218,220,222),
		(224,226,228,230,232,234,236,238,240,242,244,246,248,250,252,254),
		(27,25,31,29,19,17,23,21,11,9,15,13,3,1,7,5),
		(59,57,63,61,51,49,55,53,43,41,47,45,35,33,39,37),
		(91,89,95,93,83,81,87,85,75,73,79,77,67,65,71,69),
		(123,121,127,125,115,113,119,117,107,105,111,109,99,97,103,101),
		(155,153,159,157,147,145,151,149,139,137,143,141,131,129,135,133),
		(187,185,191,189,179,177,183,181,171,169,175,173,163,161,167,165),
		(219,217,223,221,211,209,215,213,203,201,207,205,195,193,199,197),
		(251,249,255,253,243,241,247,245,235,233,239,237,227,225,231,229));
		signal mul3: table :=(  
		(0,3,6,5,12,15,10,9,24,27,30,29,20,23,18,17),
		(48,51,54,53,60,63,58,57,40,43,46,45,36,39,34,33),
		(96,99,102,101,108,111,106,105,120,123,126,125,116,119,114,113),
		(80,83,86,85,92,95,90,89,72,75,78,77,68,71,66,65),
		(192,195,198,197,204,207,202,201,216,219,222,221,212,215,210,209),
		(240,243,246,245,252,255,250,249,232,235,238,237,228,231,226,225),
		(160,163,166,165,172,175,170,169,184,187,190,189,180,183,178,177),
		(144,147,150,149,156,159,154,153,136,139,142,141,132,135,130,129),
		(155,152,157,158,151,148,145,146,131,128,133,134,143,140,137,138),
		(171,168,173,174,167,164,161,162,179,176,181,182,191,188,185,186),
		(251,248,253,254,247,244,241,242,227,224,229,230,239,236,233,234),
		(203,200,205,206,199,196,193,194,211,208,213,214,223,220,217,218),
		(91,88,93,94,87,84,81,82,67,64,69,70,79,76,73,74),
		(107,104,109,110,103,100,97,98,115,112,117,118,127,124,121,122),
		(59,56,61,62,55,52,49,50,35,32,37,38,47,44,41,42),
		(11,8,13,14,7,4,1,2,19,16,21,22,31,28,25,26));
begin
--initializing the Rcon table
Rcon(0,0)<=01;Rcon(1,0)<=00;Rcon(2,0)<=00;Rcon(3,0)<=00;
Rcon(0,1)<=02;Rcon(1,1)<=00;Rcon(2,1)<=00;Rcon(3,1)<=00;
Rcon(0,2)<=04;Rcon(1,2)<=00;Rcon(2,2)<=00;Rcon(3,2)<=00;
Rcon(0,3)<=08;Rcon(1,3)<=00;Rcon(2,3)<=00;Rcon(3,3)<=00;
Rcon(0,4)<=16;Rcon(1,4)<=00;Rcon(2,4)<=00;Rcon(3,4)<=00;
Rcon(0,5)<=32;Rcon(1,5)<=00;Rcon(2,5)<=00;Rcon(3,5)<=00;
Rcon(0,6)<=64;Rcon(1,6)<=00;Rcon(2,6)<=00;Rcon(3,6)<=00;
Rcon(0,7)<=128;Rcon(1,7)<=00;Rcon(2,7)<=00;Rcon(3,7)<=00;
Rcon(0,8)<=27;Rcon(1,8)<=00;Rcon(2,8)<=00;Rcon(3,8)<=00;
Rcon(0,9)<=54;Rcon(1,9)<=00;Rcon(2,9)<=00;Rcon(3,9)<=00;
--initializing the s_box table
s_box_substitution(0,0)<=99;s_box_substitution(1,0)<=202;s_box_substitution(2,0)<=183;s_box_substitution(3,0)<=04;s_box_substitution(4,0)<=09;s_box_substitution(5,0)<=83;s_box_substitution(6,0)<=208;s_box_substitution(7,0)<=81;s_box_substitution(8,0)<=205;s_box_substitution(9,0)<=96;s_box_substitution(10,0)<=224;s_box_substitution(11,0)<=231;s_box_substitution(12,0)<=186;s_box_substitution(13,0)<=112;s_box_substitution(14,0)<=225;s_box_substitution(15,0)<=140;
s_box_substitution(0,1)<=124;s_box_substitution(1,1)<=130;s_box_substitution(2,1)<=253;s_box_substitution(3,1)<=199;s_box_substitution(4,1)<=131;s_box_substitution(5,1)<=209;s_box_substitution(6,1)<=239;s_box_substitution(7,1)<=163;s_box_substitution(8,1)<=12;s_box_substitution(9,1)<=129;s_box_substitution(10,1)<=50;s_box_substitution(11,1)<=200;s_box_substitution(12,1)<=120;s_box_substitution(13,1)<=62;s_box_substitution(14,1)<=248;s_box_substitution(15,1)<=161;
s_box_substitution(0,2)<=119;s_box_substitution(1,2)<=201;s_box_substitution(2,2)<=147;s_box_substitution(3,2)<=35;s_box_substitution(4,2)<=44;s_box_substitution(5,2)<=00;s_box_substitution(6,2)<=170;s_box_substitution(7,2)<=64;s_box_substitution(8,2)<=19;s_box_substitution(9,2)<=79;s_box_substitution(10,2)<=58;s_box_substitution(11,2)<=55;s_box_substitution(12,2)<=37;s_box_substitution(13,2)<=181;s_box_substitution(14,2)<=152;s_box_substitution(15,2)<=137;
s_box_substitution(0,3)<=123;s_box_substitution(1,3)<=125;s_box_substitution(2,3)<=38;s_box_substitution(3,3)<=195;s_box_substitution(4,3)<=26;s_box_substitution(5,3)<=237;s_box_substitution(6,3)<=251;s_box_substitution(7,3)<=143;s_box_substitution(8,3)<=236;s_box_substitution(9,3)<=220;s_box_substitution(10,3)<=10;s_box_substitution(11,3)<=109;s_box_substitution(12,3)<=46;s_box_substitution(13,3)<=102;s_box_substitution(14,3)<=17;s_box_substitution(15,3)<=13;
s_box_substitution(0,4)<=242;s_box_substitution(1,4)<=250;s_box_substitution(2,4)<=54;s_box_substitution(3,4)<=24;s_box_substitution(4,4)<=27;s_box_substitution(5,4)<=32;s_box_substitution(6,4)<=67;s_box_substitution(7,4)<=146;s_box_substitution(8,4)<=95;s_box_substitution(9,4)<=34;s_box_substitution(10,4)<=73;s_box_substitution(11,4)<=141;s_box_substitution(12,4)<=28;s_box_substitution(13,4)<=72;s_box_substitution(14,4)<=105;s_box_substitution(15,4)<=191;
s_box_substitution(0,5)<=107;s_box_substitution(1,5)<=89;s_box_substitution(2,5)<=63;s_box_substitution(3,5)<=150;s_box_substitution(4,5)<=110;s_box_substitution(5,5)<=252;s_box_substitution(6,5)<=77;s_box_substitution(7,5)<=157;s_box_substitution(8,5)<=151;s_box_substitution(9,5)<=42;s_box_substitution(10,5)<=06;s_box_substitution(11,5)<=213;s_box_substitution(12,5)<=166;s_box_substitution(13,5)<=03;s_box_substitution(14,5)<=217;s_box_substitution(15,5)<=230;
s_box_substitution(0,6)<=111;s_box_substitution(1,6)<=71;s_box_substitution(2,6)<=247;s_box_substitution(3,6)<=05;s_box_substitution(4,6)<=90;s_box_substitution(5,6)<=177;s_box_substitution(6,6)<=51;s_box_substitution(7,6)<=56;s_box_substitution(8,6)<=68;s_box_substitution(9,6)<=144;s_box_substitution(10,6)<=36;s_box_substitution(11,6)<=78;s_box_substitution(12,6)<=180;s_box_substitution(13,6)<=246;s_box_substitution(14,6)<=142;s_box_substitution(15,6)<=66;
s_box_substitution(0,7)<=197;s_box_substitution(1,7)<=240;s_box_substitution(2,7)<=204;s_box_substitution(3,7)<=154;s_box_substitution(4,7)<=160;s_box_substitution(5,7)<=91;s_box_substitution(6,7)<=133;s_box_substitution(7,7)<=245;s_box_substitution(8,7)<=23;s_box_substitution(9,7)<=136;s_box_substitution(10,7)<=92;s_box_substitution(11,7)<=169;s_box_substitution(12,7)<=198;s_box_substitution(13,7)<=14;s_box_substitution(14,7)<=148;s_box_substitution(15,7)<=104;
s_box_substitution(0,8)<=48;s_box_substitution(1,8)<=173;s_box_substitution(2,8)<=52;s_box_substitution(3,8)<=07;s_box_substitution(4,8)<=82;s_box_substitution(5,8)<=106;s_box_substitution(6,8)<=69;s_box_substitution(7,8)<=188;s_box_substitution(8,8)<=196;s_box_substitution(9,8)<=70;s_box_substitution(10,8)<=194;s_box_substitution(11,8)<=108;s_box_substitution(12,8)<=232;s_box_substitution(13,8)<=97;s_box_substitution(14,8)<=155;s_box_substitution(15,8)<=65;
s_box_substitution(0,9)<=01;s_box_substitution(1,9)<=212;s_box_substitution(2,9)<=165;s_box_substitution(3,9)<=18;s_box_substitution(4,9)<=59;s_box_substitution(5,9)<=203;s_box_substitution(6,9)<=249;s_box_substitution(7,9)<=182;s_box_substitution(8,9)<=167;s_box_substitution(9,9)<=238;s_box_substitution(10,9)<=211;s_box_substitution(11,9)<=86;s_box_substitution(12,9)<=221;s_box_substitution(13,9)<=53;s_box_substitution(14,9)<=30;s_box_substitution(15,9)<=153;
s_box_substitution(0,10)<=103;s_box_substitution(1,10)<=162;s_box_substitution(2,10)<=229;s_box_substitution(3,10)<=128;s_box_substitution(4,10)<=214;s_box_substitution(5,10)<=190;s_box_substitution(6,10)<=02;s_box_substitution(7,10)<=218;s_box_substitution(8,10)<=126;s_box_substitution(9,10)<=184;s_box_substitution(10,10)<=172;s_box_substitution(11,10)<=244;s_box_substitution(12,10)<=116;s_box_substitution(13,10)<=87;s_box_substitution(14,10)<=135;s_box_substitution(15,10)<=45;
s_box_substitution(0,11)<=43;s_box_substitution(1,11)<=175;s_box_substitution(2,11)<=241;s_box_substitution(3,11)<=226;s_box_substitution(4,11)<=179;s_box_substitution(5,11)<=57;s_box_substitution(6,11)<=127;s_box_substitution(7,11)<=33;s_box_substitution(8,11)<=61;s_box_substitution(9,11)<=20;s_box_substitution(10,11)<=98;s_box_substitution(11,11)<=234;s_box_substitution(12,11)<=31;s_box_substitution(13,11)<=185;s_box_substitution(14,11)<=233;s_box_substitution(15,11)<=15;
s_box_substitution(0,12)<=254;s_box_substitution(1,12)<=156;s_box_substitution(2,12)<=113;s_box_substitution(3,12)<=235;s_box_substitution(4,12)<=41;s_box_substitution(5,12)<=74;s_box_substitution(6,12)<=80;s_box_substitution(7,12)<=16;s_box_substitution(8,12)<=100;s_box_substitution(9,12)<=222;s_box_substitution(10,12)<=145;s_box_substitution(11,12)<=101;s_box_substitution(12,12)<=75;s_box_substitution(13,12)<=134;s_box_substitution(14,12)<=206;s_box_substitution(15,12)<=176;
s_box_substitution(0,13)<=215;s_box_substitution(1,13)<=164;s_box_substitution(2,13)<=216;s_box_substitution(3,13)<=39;s_box_substitution(4,13)<=227;s_box_substitution(5,13)<=76;s_box_substitution(6,13)<=60;s_box_substitution(7,13)<=255;s_box_substitution(8,13)<=93;s_box_substitution(9,13)<=94;s_box_substitution(10,13)<=149;s_box_substitution(11,13)<=122;s_box_substitution(12,13)<=189;s_box_substitution(13,13)<=193;s_box_substitution(14,13)<=85;s_box_substitution(15,13)<=84;
s_box_substitution(0,14)<=171;s_box_substitution(1,14)<=114;s_box_substitution(2,14)<=49;s_box_substitution(3,14)<=178;s_box_substitution(4,14)<=47;s_box_substitution(5,14)<=88;s_box_substitution(6,14)<=159;s_box_substitution(7,14)<=243;s_box_substitution(8,14)<=25;s_box_substitution(9,14)<=11;s_box_substitution(10,14)<=228;s_box_substitution(11,14)<=174;s_box_substitution(12,14)<=139;s_box_substitution(13,14)<=29;s_box_substitution(14,14)<=40;s_box_substitution(15,14)<=187;
s_box_substitution(0,15)<=118;s_box_substitution(1,15)<=192;s_box_substitution(2,15)<=21;s_box_substitution(3,15)<=117;s_box_substitution(4,15)<=132;s_box_substitution(5,15)<=207;s_box_substitution(6,15)<=168;s_box_substitution(7,15)<=210;s_box_substitution(8,15)<=115;s_box_substitution(9,15)<=219;s_box_substitution(10,15)<=121;s_box_substitution(11,15)<=08;s_box_substitution(12,15)<=138;s_box_substitution(13,15)<=158;s_box_substitution(14,15)<=223;s_box_substitution(15,15)<=22;
--initializing the key "should be random"
key(0,0)<=43;key(0,1)<=40 ;key(0,2)<=171;key(0,3)<=9;key(1,0)<=126;key(1,1)<=174;key(1,2)<=247;key(1,3)<=207;key(2,0)<=21;key(2,1)<=210;key(2,2)<=21;key(2,3)<=79;key(3,0)<=22;key(3,1)<=166;key(3,2)<=136;key(3,3)<=60;
process(switch)
--initializong the input matrix
variable i : matrix;
variable temp: integer;
variable temp1: matrix;
variable temp2: matrix;
variable temp3 : matrix;
variable f: integer;
variable g: integer;
variable k:matrix;
variable round1: matrix;variable round2: matrix;variable round3: matrix;variable round4: matrix;variable round5: matrix;variable round6: matrix;variable round7: matrix;variable round8: matrix;variable round9: matrix;variable round10: matrix;
variable row: integer;
variable a: integer;
variable b: integer;
variable s: integer;
variable t: integer;
variable u: integer;
variable v: integer;
variable w: integer;
variable x: integer;
variable y: integer;
variable z: integer;
variable counter: integer := 0;
begin 
i:=((50,136,49,224),(67,90,49,55),(246,48,152,07),(168,141,162,52));
k:=key;
	   --Round 1 Key
	   temp :=k(0,3);
		k(0,3):=k(1,3);
		k(1,3):=k(2,3);
		k(2,3):=k(3,3);
		k(3,3):=temp;
		for counter in 3 downto 0 loop
				f := k(counter,3) / 16;
				g := k(counter,3) mod 16;
				k(counter,3):= s_box_substitution(f,g);
	end loop;
		round1(0,0):= to_integer(((to_unsigned(k(0,0),8)) xor (to_unsigned(k(0,3),8)) xor (to_unsigned(Rcon(0,0),8))));
		round1(1,0):= to_integer(((to_unsigned(k(1,0),8)) xor (to_unsigned(k(1,3),8)) xor (to_unsigned(Rcon(1,0),8))));
		round1(2,0):= to_integer(((to_unsigned(k(2,0),8)) xor (to_unsigned(k(2,3),8)) xor (to_unsigned(Rcon(2,0),8))));
		round1(3,0):= to_integer(((to_unsigned(k(3,0),8)) xor (to_unsigned(k(3,3),8)) xor (to_unsigned(Rcon(3,0),8))));
		round1(0,1):= to_integer(((to_unsigned(k(0,1),8)) xor (to_unsigned(round1(0,0),8))));
		round1(1,1):= to_integer(((to_unsigned(k(1,1),8)) xor (to_unsigned(round1(1,0),8))));
		round1(2,1):= to_integer(((to_unsigned(k(2,1),8)) xor (to_unsigned(round1(2,0),8))));
		round1(3,1):= to_integer(((to_unsigned(k(3,1),8)) xor (to_unsigned(round1(3,0),8))));	
		round1(0,2):= to_integer(((to_unsigned(k(0,2),8)) xor (to_unsigned(round1(0,1),8))));
		round1(1,2):= to_integer(((to_unsigned(k(1,2),8)) xor (to_unsigned(round1(1,1),8))));
		round1(2,2):= to_integer(((to_unsigned(k(2,2),8)) xor (to_unsigned(round1(2,1),8))));
		round1(3,2):= to_integer(((to_unsigned(k(3,2),8)) xor (to_unsigned(round1(3,1),8))));
		round1(0,3):= to_integer(((to_unsigned(key(0,3),8)) xor (to_unsigned(round1(0,2),8))));
		round1(1,3):= to_integer(((to_unsigned(key(1,3),8)) xor (to_unsigned(round1(1,2),8))));
		round1(2,3):= to_integer(((to_unsigned(key(2,3),8)) xor (to_unsigned(round1(2,2),8))));
		round1(3,3):= to_integer(((to_unsigned(key(3,3),8)) xor (to_unsigned(round1(3,2),8))));	
		--Round 2 Key
		k:=round1;
		temp :=k(0,3);
		k(0,3):=k(1,3);
		k(1,3):=k(2,3);
		k(2,3):=k(3,3);
		k(3,3):=temp;
		for counter in 3 downto 0 loop
				f := k(counter,3) / 16;
				g := k(counter,3) mod 16;
				k(counter,3):= to_integer(to_unsigned((s_box_substitution(f,g)),8));
		end loop;
   	round2(0,0):= to_integer(((to_unsigned(k(0,0),8)) xor (to_unsigned(k(0,3),8)) xor (to_unsigned(Rcon(0,1),8))));
		round2(1,0):= to_integer(((to_unsigned(k(1,0),8)) xor (to_unsigned(k(1,3),8)) xor (to_unsigned(Rcon(1,1),8))));
		round2(2,0):= to_integer(((to_unsigned(k(2,0),8)) xor (to_unsigned(k(2,3),8)) xor (to_unsigned(Rcon(2,1),8))));
		round2(3,0):= to_integer(((to_unsigned(k(3,0),8)) xor (to_unsigned(k(3,3),8)) xor (to_unsigned(Rcon(3,1),8))));
		round2(0,1):= to_integer((to_unsigned(k(0,1),8) xor to_unsigned(round2(0,0),8)));
		round2(1,1):= to_integer((to_unsigned(k(1,1),8) xor to_unsigned(round2(1,0),8)));
		round2(2,1):= to_integer((to_unsigned(k(2,1),8) xor to_unsigned(round2(2,0),8)));
		round2(3,1):= to_integer((to_unsigned(k(3,1),8) xor to_unsigned(round2(3,0),8)));	
		round2(0,2):= to_integer((to_unsigned(k(0,2),8) xor to_unsigned(round2(0,1),8)));
		round2(1,2):= to_integer((to_unsigned(k(1,2),8) xor to_unsigned(round2(1,1),8)));
		round2(2,2):= to_integer((to_unsigned(k(2,2),8) xor to_unsigned(round2(2,1),8)));
		round2(3,2):= to_integer((to_unsigned(k(3,2),8) xor to_unsigned(round2(3,1),8)));
		round2(0,3):= to_integer((to_unsigned(round1(0,3),8) xor to_unsigned(round2(0,2),8)));
		round2(1,3):= to_integer((to_unsigned(round1(1,3),8) xor to_unsigned(round2(1,2),8)));
		round2(2,3):= to_integer((to_unsigned(round1(2,3),8) xor to_unsigned(round2(2,2),8)));
		round2(3,3):= to_integer((to_unsigned(round1(3,3),8) xor to_unsigned(round2(3,2),8)));
		--Round 3 Key
		k:=round2;
		temp :=k(0,3);
		k(0,3):=k(1,3);
		k(1,3):=k(2,3);
		k(2,3):=k(3,3);
		k(3,3):=temp;
		for counter in 3 downto 0 loop
				f := k(counter,3) / 16;
				g := k(counter,3) mod 16;
				k(counter,3):= to_integer(to_unsigned((s_box_substitution(f,g)),8));
		end loop;
   	round3(0,0):= to_integer(((to_unsigned(k(0,0),8)) xor (to_unsigned(k(0,3),8)) xor (to_unsigned(Rcon(0,2),8))));
		round3(1,0):= to_integer(((to_unsigned(k(1,0),8)) xor (to_unsigned(k(1,3),8)) xor (to_unsigned(Rcon(1,2),8))));
		round3(2,0):= to_integer(((to_unsigned(k(2,0),8)) xor (to_unsigned(k(2,3),8)) xor (to_unsigned(Rcon(2,2),8))));
		round3(3,0):= to_integer(((to_unsigned(k(3,0),8)) xor (to_unsigned(k(3,3),8)) xor (to_unsigned(Rcon(3,2),8))));
		round3(0,1):= to_integer((to_unsigned(k(0,1),8) xor to_unsigned(round3(0,0),8)));
		round3(1,1):= to_integer((to_unsigned(k(1,1),8) xor to_unsigned(round3(1,0),8)));
		round3(2,1):= to_integer((to_unsigned(k(2,1),8) xor to_unsigned(round3(2,0),8)));
		round3(3,1):= to_integer((to_unsigned(k(3,1),8) xor to_unsigned(round3(3,0),8)));	
		round3(0,2):= to_integer((to_unsigned(k(0,2),8) xor to_unsigned(round3(0,1),8)));
		round3(1,2):= to_integer((to_unsigned(k(1,2),8) xor to_unsigned(round3(1,1),8)));
		round3(2,2):= to_integer((to_unsigned(k(2,2),8) xor to_unsigned(round3(2,1),8)));
		round3(3,2):= to_integer((to_unsigned(k(3,2),8) xor to_unsigned(round3(3,1),8)));
		round3(0,3):= to_integer((to_unsigned(round2(0,3),8) xor to_unsigned(round3(0,2),8)));
		round3(1,3):= to_integer((to_unsigned(round2(1,3),8) xor to_unsigned(round3(1,2),8)));
		round3(2,3):= to_integer((to_unsigned(round2(2,3),8) xor to_unsigned(round3(2,2),8)));
		round3(3,3):= to_integer((to_unsigned(round2(3,3),8) xor to_unsigned(round3(3,2),8)));
		--Round 4 Key
		k:=round3;
		temp :=k(0,3);
		k(0,3):=k(1,3);
		k(1,3):=k(2,3);
		k(2,3):=k(3,3);
		k(3,3):=temp;
		for counter in 3 downto 0 loop
				f := k(counter,3) / 16;
				g := k(counter,3) mod 16;
				k(counter,3):= to_integer(to_unsigned((s_box_substitution(f,g)),8));
		end loop;
   	round4(0,0):= to_integer(((to_unsigned(k(0,0),8)) xor (to_unsigned(k(0,3),8)) xor (to_unsigned(Rcon(0,3),8))));
		round4(1,0):= to_integer(((to_unsigned(k(1,0),8)) xor (to_unsigned(k(1,3),8)) xor (to_unsigned(Rcon(1,3),8))));
		round4(2,0):= to_integer(((to_unsigned(k(2,0),8)) xor (to_unsigned(k(2,3),8)) xor (to_unsigned(Rcon(2,3),8))));
		round4(3,0):= to_integer(((to_unsigned(k(3,0),8)) xor (to_unsigned(k(3,3),8)) xor (to_unsigned(Rcon(3,3),8))));
		round4(0,1):= to_integer((to_unsigned(k(0,1),8) xor to_unsigned(round4(0,0),8)));
		round4(1,1):= to_integer((to_unsigned(k(1,1),8) xor to_unsigned(round4(1,0),8)));
		round4(2,1):= to_integer((to_unsigned(k(2,1),8) xor to_unsigned(round4(2,0),8)));
		round4(3,1):= to_integer((to_unsigned(k(3,1),8) xor to_unsigned(round4(3,0),8)));	
		round4(0,2):= to_integer((to_unsigned(k(0,2),8) xor to_unsigned(round4(0,1),8)));
		round4(1,2):= to_integer((to_unsigned(k(1,2),8) xor to_unsigned(round4(1,1),8)));
		round4(2,2):= to_integer((to_unsigned(k(2,2),8) xor to_unsigned(round4(2,1),8)));
		round4(3,2):= to_integer((to_unsigned(k(3,2),8) xor to_unsigned(round4(3,1),8)));
		round4(0,3):= to_integer((to_unsigned(round3(0,3),8) xor to_unsigned(round4(0,2),8)));
		round4(1,3):= to_integer((to_unsigned(round3(1,3),8) xor to_unsigned(round4(1,2),8)));
		round4(2,3):= to_integer((to_unsigned(round3(2,3),8) xor to_unsigned(round4(2,2),8)));
		round4(3,3):= to_integer((to_unsigned(round3(3,3),8) xor to_unsigned(round4(3,2),8)));
		--Round 5 Key
		k:=round4;
		temp :=k(0,3);
		k(0,3):=k(1,3);
		k(1,3):=k(2,3);
		k(2,3):=k(3,3);
		k(3,3):=temp;
		for counter in 3 downto 0 loop
				f := k(counter,3) / 16;
				g := k(counter,3) mod 16;
				k(counter,3):= to_integer(to_unsigned((s_box_substitution(f,g)),8));
		end loop;
   	round5(0,0):= to_integer(((to_unsigned(k(0,0),8)) xor (to_unsigned(k(0,3),8)) xor (to_unsigned(Rcon(0,4),8))));
		round5(1,0):= to_integer(((to_unsigned(k(1,0),8)) xor (to_unsigned(k(1,3),8)) xor (to_unsigned(Rcon(1,4),8))));
		round5(2,0):= to_integer(((to_unsigned(k(2,0),8)) xor (to_unsigned(k(2,3),8)) xor (to_unsigned(Rcon(2,4),8))));
		round5(3,0):= to_integer(((to_unsigned(k(3,0),8)) xor (to_unsigned(k(3,3),8)) xor (to_unsigned(Rcon(3,4),8))));
		round5(0,1):= to_integer((to_unsigned(k(0,1),8) xor to_unsigned(round5(0,0),8)));
		round5(1,1):= to_integer((to_unsigned(k(1,1),8) xor to_unsigned(round5(1,0),8)));
		round5(2,1):= to_integer((to_unsigned(k(2,1),8) xor to_unsigned(round5(2,0),8)));
		round5(3,1):= to_integer((to_unsigned(k(3,1),8) xor to_unsigned(round5(3,0),8)));	
		round5(0,2):= to_integer((to_unsigned(k(0,2),8) xor to_unsigned(round5(0,1),8)));
		round5(1,2):= to_integer((to_unsigned(k(1,2),8) xor to_unsigned(round5(1,1),8)));
		round5(2,2):= to_integer((to_unsigned(k(2,2),8) xor to_unsigned(round5(2,1),8)));
		round5(3,2):= to_integer((to_unsigned(k(3,2),8) xor to_unsigned(round5(3,1),8)));
		round5(0,3):= to_integer((to_unsigned(round4(0,3),8) xor to_unsigned(round5(0,2),8)));
		round5(1,3):= to_integer((to_unsigned(round4(1,3),8) xor to_unsigned(round5(1,2),8)));
		round5(2,3):= to_integer((to_unsigned(round4(2,3),8) xor to_unsigned(round5(2,2),8)));
		round5(3,3):= to_integer((to_unsigned(round4(3,3),8) xor to_unsigned(round5(3,2),8)));
		--Round 6 Key
		k:=round5;
		temp :=k(0,3);
		k(0,3):=k(1,3);
		k(1,3):=k(2,3);
		k(2,3):=k(3,3);
		k(3,3):=temp;
		for counter in 3 downto 0 loop
				f := k(counter,3) / 16;
				g := k(counter,3) mod 16;
				k(counter,3):= to_integer(to_unsigned((s_box_substitution(f,g)),8));
		end loop;
   	round6(0,0):= to_integer(((to_unsigned(k(0,0),8)) xor (to_unsigned(k(0,3),8)) xor (to_unsigned(Rcon(0,5),8))));
		round6(1,0):= to_integer(((to_unsigned(k(1,0),8)) xor (to_unsigned(k(1,3),8)) xor (to_unsigned(Rcon(1,5),8))));
		round6(2,0):= to_integer(((to_unsigned(k(2,0),8)) xor (to_unsigned(k(2,3),8)) xor (to_unsigned(Rcon(2,5),8))));
		round6(3,0):= to_integer(((to_unsigned(k(3,0),8)) xor (to_unsigned(k(3,3),8)) xor (to_unsigned(Rcon(3,5),8))));
		round6(0,1):= to_integer((to_unsigned(k(0,1),8) xor to_unsigned(round6(0,0),8)));
		round6(1,1):= to_integer((to_unsigned(k(1,1),8) xor to_unsigned(round6(1,0),8)));
		round6(2,1):= to_integer((to_unsigned(k(2,1),8) xor to_unsigned(round6(2,0),8)));
		round6(3,1):= to_integer((to_unsigned(k(3,1),8) xor to_unsigned(round6(3,0),8)));	
		round6(0,2):= to_integer((to_unsigned(k(0,2),8) xor to_unsigned(round6(0,1),8)));
		round6(1,2):= to_integer((to_unsigned(k(1,2),8) xor to_unsigned(round6(1,1),8)));
		round6(2,2):= to_integer((to_unsigned(k(2,2),8) xor to_unsigned(round6(2,1),8)));
		round6(3,2):= to_integer((to_unsigned(k(3,2),8) xor to_unsigned(round6(3,1),8)));
		round6(0,3):= to_integer((to_unsigned(round5(0,3),8) xor to_unsigned(round6(0,2),8)));
		round6(1,3):= to_integer((to_unsigned(round5(1,3),8) xor to_unsigned(round6(1,2),8)));
		round6(2,3):= to_integer((to_unsigned(round5(2,3),8) xor to_unsigned(round6(2,2),8)));
		round6(3,3):= to_integer((to_unsigned(round5(3,3),8) xor to_unsigned(round6(3,2),8)));
		--Round 7 Key
		k:=round6;
		temp :=k(0,3);
		k(0,3):=k(1,3);
		k(1,3):=k(2,3);
		k(2,3):=k(3,3);
		k(3,3):=temp;
		for counter in 3 downto 0 loop
				f := k(counter,3) / 16;
				g := k(counter,3) mod 16;
				k(counter,3):= to_integer(to_unsigned((s_box_substitution(f,g)),8));
		end loop;
   	round7(0,0):= to_integer(((to_unsigned(k(0,0),8)) xor (to_unsigned(k(0,3),8)) xor (to_unsigned(Rcon(0,6),8))));
		round7(1,0):= to_integer(((to_unsigned(k(1,0),8)) xor (to_unsigned(k(1,3),8)) xor (to_unsigned(Rcon(1,6),8))));
		round7(2,0):= to_integer(((to_unsigned(k(2,0),8)) xor (to_unsigned(k(2,3),8)) xor (to_unsigned(Rcon(2,6),8))));
		round7(3,0):= to_integer(((to_unsigned(k(3,0),8)) xor (to_unsigned(k(3,3),8)) xor (to_unsigned(Rcon(3,6),8))));
		round7(0,1):= to_integer((to_unsigned(k(0,1),8) xor to_unsigned(round7(0,0),8)));
		round7(1,1):= to_integer((to_unsigned(k(1,1),8) xor to_unsigned(round7(1,0),8)));
		round7(2,1):= to_integer((to_unsigned(k(2,1),8) xor to_unsigned(round7(2,0),8)));
		round7(3,1):= to_integer((to_unsigned(k(3,1),8) xor to_unsigned(round7(3,0),8)));	
		round7(0,2):= to_integer((to_unsigned(k(0,2),8) xor to_unsigned(round7(0,1),8)));
		round7(1,2):= to_integer((to_unsigned(k(1,2),8) xor to_unsigned(round7(1,1),8)));
		round7(2,2):= to_integer((to_unsigned(k(2,2),8) xor to_unsigned(round7(2,1),8)));
		round7(3,2):= to_integer((to_unsigned(k(3,2),8) xor to_unsigned(round7(3,1),8)));
		round7(0,3):= to_integer((to_unsigned(round6(0,3),8) xor to_unsigned(round7(0,2),8)));
		round7(1,3):= to_integer((to_unsigned(round6(1,3),8) xor to_unsigned(round7(1,2),8)));
		round7(2,3):= to_integer((to_unsigned(round6(2,3),8) xor to_unsigned(round7(2,2),8)));
		round7(3,3):= to_integer((to_unsigned(round6(3,3),8) xor to_unsigned(round7(3,2),8)));
		--Round 8 Key
		k:=round7;
		temp :=k(0,3);
		k(0,3):=k(1,3);
		k(1,3):=k(2,3);
		k(2,3):=k(3,3);
		k(3,3):=temp;
		for counter in 3 downto 0 loop
				f := k(counter,3) / 16;
				g := k(counter,3) mod 16;
				k(counter,3):= to_integer(to_unsigned((s_box_substitution(f,g)),8));
		end loop;
   	round8(0,0):= to_integer(((to_unsigned(k(0,0),8)) xor (to_unsigned(k(0,3),8)) xor (to_unsigned(Rcon(0,7),8))));
		round8(1,0):= to_integer(((to_unsigned(k(1,0),8)) xor (to_unsigned(k(1,3),8)) xor (to_unsigned(Rcon(1,7),8))));
		round8(2,0):= to_integer(((to_unsigned(k(2,0),8)) xor (to_unsigned(k(2,3),8)) xor (to_unsigned(Rcon(2,7),8))));
		round8(3,0):= to_integer(((to_unsigned(k(3,0),8)) xor (to_unsigned(k(3,3),8)) xor (to_unsigned(Rcon(3,7),8))));
		round8(0,1):= to_integer((to_unsigned(k(0,1),8) xor to_unsigned(round8(0,0),8)));
		round8(1,1):= to_integer((to_unsigned(k(1,1),8) xor to_unsigned(round8(1,0),8)));
		round8(2,1):= to_integer((to_unsigned(k(2,1),8) xor to_unsigned(round8(2,0),8)));
		round8(3,1):= to_integer((to_unsigned(k(3,1),8) xor to_unsigned(round8(3,0),8)));	
		round8(0,2):= to_integer((to_unsigned(k(0,2),8) xor to_unsigned(round8(0,1),8)));
		round8(1,2):= to_integer((to_unsigned(k(1,2),8) xor to_unsigned(round8(1,1),8)));
		round8(2,2):= to_integer((to_unsigned(k(2,2),8) xor to_unsigned(round8(2,1),8)));
		round8(3,2):= to_integer((to_unsigned(k(3,2),8) xor to_unsigned(round8(3,1),8)));
		round8(0,3):= to_integer((to_unsigned(round7(0,3),8) xor to_unsigned(round8(0,2),8)));
		round8(1,3):= to_integer((to_unsigned(round7(1,3),8) xor to_unsigned(round8(1,2),8)));
		round8(2,3):= to_integer((to_unsigned(round7(2,3),8) xor to_unsigned(round8(2,2),8)));
		round8(3,3):= to_integer((to_unsigned(round7(3,3),8) xor to_unsigned(round8(3,2),8)));
		--Round 9 Key
		k:=round8;
		temp :=k(0,3);
		k(0,3):=k(1,3);
		k(1,3):=k(2,3);
		k(2,3):=k(3,3);
		k(3,3):=temp;
		for counter in 3 downto 0 loop
				f := k(counter,3) / 16;
				g := k(counter,3) mod 16;
				k(counter,3):= to_integer(to_unsigned((s_box_substitution(f,g)),8));
		end loop;
   	round9(0,0):= to_integer(((to_unsigned(k(0,0),8)) xor (to_unsigned(k(0,3),8)) xor (to_unsigned(Rcon(0,8),8))));
		round9(1,0):= to_integer(((to_unsigned(k(1,0),8)) xor (to_unsigned(k(1,3),8)) xor (to_unsigned(Rcon(1,8),8))));
		round9(2,0):= to_integer(((to_unsigned(k(2,0),8)) xor (to_unsigned(k(2,3),8)) xor (to_unsigned(Rcon(2,8),8))));
		round9(3,0):= to_integer(((to_unsigned(k(3,0),8)) xor (to_unsigned(k(3,3),8)) xor (to_unsigned(Rcon(3,8),8))));
		round9(0,1):= to_integer((to_unsigned(k(0,1),8) xor to_unsigned(round9(0,0),8)));
		round9(1,1):= to_integer((to_unsigned(k(1,1),8) xor to_unsigned(round9(1,0),8)));
		round9(2,1):= to_integer((to_unsigned(k(2,1),8) xor to_unsigned(round9(2,0),8)));
		round9(3,1):= to_integer((to_unsigned(k(3,1),8) xor to_unsigned(round9(3,0),8)));	
		round9(0,2):= to_integer((to_unsigned(k(0,2),8) xor to_unsigned(round9(0,1),8)));
		round9(1,2):= to_integer((to_unsigned(k(1,2),8) xor to_unsigned(round9(1,1),8)));
		round9(2,2):= to_integer((to_unsigned(k(2,2),8) xor to_unsigned(round9(2,1),8)));
		round9(3,2):= to_integer((to_unsigned(k(3,2),8) xor to_unsigned(round9(3,1),8)));
		round9(0,3):= to_integer((to_unsigned(round8(0,3),8) xor to_unsigned(round9(0,2),8)));
		round9(1,3):= to_integer((to_unsigned(round8(1,3),8) xor to_unsigned(round9(1,2),8)));
		round9(2,3):= to_integer((to_unsigned(round8(2,3),8) xor to_unsigned(round9(2,2),8)));
		round9(3,3):= to_integer((to_unsigned(round8(3,3),8) xor to_unsigned(round9(3,2),8)));
		--Round 10 Key
		k:=round9;
		temp :=k(0,3);
		k(0,3):=k(1,3);
		k(1,3):=k(2,3);
		k(2,3):=k(3,3);
		k(3,3):=temp;
		for counter in 3 downto 0 loop
				f := k(counter,3) / 16;
				g := k(counter,3) mod 16;
				k(counter,3):= to_integer(to_unsigned((s_box_substitution(f,g)),8));
		end loop;
   	round10(0,0):= to_integer(((to_unsigned(k(0,0),8)) xor (to_unsigned(k(0,3),8)) xor (to_unsigned(Rcon(0,9),8))));
		round10(1,0):= to_integer(((to_unsigned(k(1,0),8)) xor (to_unsigned(k(1,3),8)) xor (to_unsigned(Rcon(1,9),8))));
		round10(2,0):= to_integer(((to_unsigned(k(2,0),8)) xor (to_unsigned(k(2,3),8)) xor (to_unsigned(Rcon(2,9),8))));
		round10(3,0):= to_integer(((to_unsigned(k(3,0),8)) xor (to_unsigned(k(3,3),8)) xor (to_unsigned(Rcon(3,9),8))));
		round10(0,1):= to_integer((to_unsigned(k(0,1),8) xor to_unsigned(round10(0,0),8)));
		round10(1,1):= to_integer((to_unsigned(k(1,1),8) xor to_unsigned(round10(1,0),8)));
		round10(2,1):= to_integer((to_unsigned(k(2,1),8) xor to_unsigned(round10(2,0),8)));
		round10(3,1):= to_integer((to_unsigned(k(3,1),8) xor to_unsigned(round10(3,0),8)));	
		round10(0,2):= to_integer((to_unsigned(k(0,2),8) xor to_unsigned(round10(0,1),8)));
		round10(1,2):= to_integer((to_unsigned(k(1,2),8) xor to_unsigned(round10(1,1),8)));
		round10(2,2):= to_integer((to_unsigned(k(2,2),8) xor to_unsigned(round10(2,1),8)));
		round10(3,2):= to_integer((to_unsigned(k(3,2),8) xor to_unsigned(round10(3,1),8)));
		round10(0,3):= to_integer((to_unsigned(round9(0,3),8) xor to_unsigned(round10(0,2),8)));
		round10(1,3):= to_integer((to_unsigned(round9(1,3),8) xor to_unsigned(round10(1,2),8)));
		round10(2,3):= to_integer((to_unsigned(round9(2,3),8) xor to_unsigned(round10(2,2),8)));
		round10(3,3):= to_integer((to_unsigned(round9(3,3),8) xor to_unsigned(round10(3,2),8)));	--starting the 10 rounds
--Starting the 10 rounds
--XOR Round
i(0,0):= to_integer(((to_unsigned(i(0,0),8)) xor (to_unsigned(key(0,0),8))));
i(1,0):= to_integer(((to_unsigned(i(1,0),8)) xor (to_unsigned(key(1,0),8))));
i(2,0):= to_integer(((to_unsigned(i(2,0),8)) xor (to_unsigned(key(2,0),8))));
i(3,0):= to_integer(((to_unsigned(i(3,0),8)) xor (to_unsigned(key(3,0),8))));
i(0,1):= to_integer(((to_unsigned(i(0,1),8)) xor (to_unsigned(key(0,1),8))));
i(1,1):= to_integer(((to_unsigned(i(1,1),8)) xor (to_unsigned(key(1,1),8))));
i(2,1):= to_integer(((to_unsigned(i(2,1),8)) xor (to_unsigned(key(2,1),8))));
i(3,1):= to_integer(((to_unsigned(i(3,1),8)) xor (to_unsigned(key(3,1),8))));
i(0,2):= to_integer(((to_unsigned(i(0,2),8)) xor (to_unsigned(key(0,2),8))));
i(1,2):= to_integer(((to_unsigned(i(1,2),8)) xor (to_unsigned(key(1,2),8))));
i(2,2):= to_integer(((to_unsigned(i(2,2),8)) xor (to_unsigned(key(2,2),8))));
i(3,2):= to_integer(((to_unsigned(i(3,2),8)) xor (to_unsigned(key(3,2),8))));
i(0,3):= to_integer(((to_unsigned(i(0,3),8)) xor (to_unsigned(key(0,3),8))));
i(1,3):= to_integer(((to_unsigned(i(1,3),8)) xor (to_unsigned(key(1,3),8))));
i(2,3):= to_integer(((to_unsigned(i(2,3),8)) xor (to_unsigned(key(2,3),8))));
i(3,3):= to_integer(((to_unsigned(i(3,3),8)) xor (to_unsigned(key(3,3),8))));
--round 1
--SubBytes
	for counter in 3 downto 0 loop
		for counter2 in 3 downto 0 loop
			a := i(counter,counter2) / 16;
			b := i(counter,counter2) mod 16;
			i(counter,counter2):= s_box_substitution(a,b);
		end loop;
	end loop;
	--ShiftRows
	row :=i(1,0);
	i(1,0):=i(1,1);
	i(1,1):=i(1,2);
	i(1,2):=i(1,3);
	i(1,3):=row;
	for counter in 2 downto 1 loop
	row :=i(2,0);
	i(2,0):=i(2,1);
	i(2,1):=i(2,2);
	i(2,2):=i(2,3);
	i(2,3):=row;
	end loop;
	for counter in 3 downto 1 loop
	row :=i(3,0);
	i(3,0):=i(3,1);
	i(3,1):=i(3,2);
	i(3,2):=i(3,3);
	i(3,3):=row;
	end loop;
		--MixColumns
		temp3 := i;
		for c in 0 to 3 loop
		s := i(0,c) mod 16;
		t := i(0,c) / 16;
		u := i(1,c) mod 16;
		v := i(1,c) / 16;
		w := i(2,c) mod 16;
		x := i(2,c) / 16;
		y := i(3,c) mod 16;
		z := i(3,c) / 16;
		i(0,c) := to_integer(((to_unsigned(mul2(t,s),8)) xor (to_unsigned(mul3(v,u),8)) xor (to_unsigned(temp3(2,c),8)) xor (to_unsigned(temp3(3,c),8))));
		i(1,c) := to_integer(((to_unsigned(temp3(0,c),8)) xor (to_unsigned(mul2(v,u),8)) xor (to_unsigned(mul3(x,w),8)) xor (to_unsigned(temp3(3,c),8))));
		i(2,c) := to_integer(((to_unsigned(temp3(0,c),8)) xor (to_unsigned(temp3(1,c),8)) xor (to_unsigned(mul2(x,w),8)) xor (to_unsigned(mul3(z,y),8))));
		i(3,c) := to_integer(((to_unsigned(mul3(t,s),8)) xor (to_unsigned(temp3(1,c),8)) xor (to_unsigned(temp3(2,c),8)) xor (to_unsigned(mul2(z,y),8))));	
		end loop;
	--AddRoundKey
			i(0,0):= to_integer(((to_unsigned(i(0,0),8)) xor (to_unsigned(round1(0,0),8))));
			i(1,0):= to_integer(((to_unsigned(i(1,0),8)) xor (to_unsigned(round1(1,0),8))));
			i(2,0):= to_integer(((to_unsigned(i(2,0),8)) xor (to_unsigned(round1(2,0),8))));
			i(3,0):= to_integer(((to_unsigned(i(3,0),8)) xor (to_unsigned(round1(3,0),8))));
			i(0,1):= to_integer(((to_unsigned(i(0,1),8)) xor (to_unsigned(round1(0,1),8))));
			i(1,1):= to_integer(((to_unsigned(i(1,1),8)) xor (to_unsigned(round1(1,1),8))));
			i(2,1):= to_integer(((to_unsigned(i(2,1),8)) xor (to_unsigned(round1(2,1),8))));
			i(3,1):= to_integer(((to_unsigned(i(3,1),8)) xor (to_unsigned(round1(3,1),8))));
			i(0,2):= to_integer(((to_unsigned(i(0,2),8)) xor (to_unsigned(round1(0,2),8))));
			i(1,2):= to_integer(((to_unsigned(i(1,2),8)) xor (to_unsigned(round1(1,2),8))));
			i(2,2):= to_integer(((to_unsigned(i(2,2),8)) xor (to_unsigned(round1(2,2),8))));
			i(3,2):= to_integer(((to_unsigned(i(3,2),8)) xor (to_unsigned(round1(3,2),8))));
			i(0,3):= to_integer(((to_unsigned(i(0,3),8)) xor (to_unsigned(round1(0,3),8))));
			i(1,3):= to_integer(((to_unsigned(i(1,3),8)) xor (to_unsigned(round1(1,3),8))));
			i(2,3):= to_integer(((to_unsigned(i(2,3),8)) xor (to_unsigned(round1(2,3),8))));
			i(3,3):= to_integer(((to_unsigned(i(3,3),8)) xor (to_unsigned(round1(3,3),8))));
--round 2
--SubBytes
	for counter in 3 downto 0 loop
		for counter2 in 3 downto 0 loop
			a := i(counter,counter2) / 16;
			b := i(counter,counter2) mod 16;
			i(counter,counter2):= s_box_substitution(a,b);
		end loop;
	end loop;
	--ShiftRows
	row :=i(1,0);
	i(1,0):=i(1,1);
	i(1,1):=i(1,2);
	i(1,2):=i(1,3);
	i(1,3):=row;
	for counter in 2 downto 1 loop
	row :=i(2,0);
	i(2,0):=i(2,1);
	i(2,1):=i(2,2);
	i(2,2):=i(2,3);
	i(2,3):=row;
	end loop;
	for counter in 3 downto 1 loop
	row :=i(3,0);
	i(3,0):=i(3,1);
	i(3,1):=i(3,2);
	i(3,2):=i(3,3);
	i(3,3):=row;
	end loop;
		--MixColumns
		temp3:=i;
	for c in 0 to 3 loop
		s := i(0,c) mod 16;
		t := i(0,c) / 16;
		u := i(1,c) mod 16;
		v := i(1,c) / 16;
		w := i(2,c) mod 16;
		x := i(2,c) / 16;
		y := i(3,c) mod 16;
		z := i(3,c) / 16;
		i(0,c) := to_integer(((to_unsigned(mul2(t,s),8)) xor (to_unsigned(mul3(v,u),8)) xor (to_unsigned(temp3(2,c),8)) xor (to_unsigned(temp3(3,c),8))));
		i(1,c) := to_integer(((to_unsigned(temp3(0,c),8)) xor (to_unsigned(mul2(v,u),8)) xor (to_unsigned(mul3(x,w),8)) xor (to_unsigned(temp3(3,c),8))));
		i(2,c) := to_integer(((to_unsigned(temp3(0,c),8)) xor (to_unsigned(temp3(1,c),8)) xor (to_unsigned(mul2(x,w),8)) xor (to_unsigned(mul3(z,y),8))));
		i(3,c) := to_integer(((to_unsigned(mul3(t,s),8)) xor (to_unsigned(temp3(1,c),8)) xor (to_unsigned(temp3(2,c),8)) xor (to_unsigned(mul2(z,y),8))));	
		end loop;
	--AddRoundKey
			i(0,0):= to_integer(((to_unsigned(i(0,0),8)) xor (to_unsigned(round2(0,0),8))));
			i(1,0):= to_integer(((to_unsigned(i(1,0),8)) xor (to_unsigned(round2(1,0),8))));
			i(2,0):= to_integer(((to_unsigned(i(2,0),8)) xor (to_unsigned(round2(2,0),8))));
			i(3,0):= to_integer(((to_unsigned(i(3,0),8)) xor (to_unsigned(round2(3,0),8))));
			i(0,1):= to_integer(((to_unsigned(i(0,1),8)) xor (to_unsigned(round2(0,1),8))));
			i(1,1):= to_integer(((to_unsigned(i(1,1),8)) xor (to_unsigned(round2(1,1),8))));
			i(2,1):= to_integer(((to_unsigned(i(2,1),8)) xor (to_unsigned(round2(2,1),8))));
			i(3,1):= to_integer(((to_unsigned(i(3,1),8)) xor (to_unsigned(round2(3,1),8))));
			i(0,2):= to_integer(((to_unsigned(i(0,2),8)) xor (to_unsigned(round2(0,2),8))));
			i(1,2):= to_integer(((to_unsigned(i(1,2),8)) xor (to_unsigned(round2(1,2),8))));
			i(2,2):= to_integer(((to_unsigned(i(2,2),8)) xor (to_unsigned(round2(2,2),8))));
			i(3,2):= to_integer(((to_unsigned(i(3,2),8)) xor (to_unsigned(round2(3,2),8))));
			i(0,3):= to_integer(((to_unsigned(i(0,3),8)) xor (to_unsigned(round2(0,3),8))));
			i(1,3):= to_integer(((to_unsigned(i(1,3),8)) xor (to_unsigned(round2(1,3),8))));
			i(2,3):= to_integer(((to_unsigned(i(2,3),8)) xor (to_unsigned(round2(2,3),8))));
			i(3,3):= to_integer(((to_unsigned(i(3,3),8)) xor (to_unsigned(round2(3,3),8))));
--round 3
--SubBytes
	for counter in 3 downto 0 loop
		for counter2 in 3 downto 0 loop
			a := i(counter,counter2) / 16;
			b := i(counter,counter2) mod 16;
			i(counter,counter2):= s_box_substitution(a,b);
		end loop;
	end loop;
	--ShiftRows
	row :=i(1,0);
	i(1,0):=i(1,1);
	i(1,1):=i(1,2);
	i(1,2):=i(1,3);
	i(1,3):=row;
	for counter in 2 downto 1 loop
	row :=i(2,0);
	i(2,0):=i(2,1);
	i(2,1):=i(2,2);
	i(2,2):=i(2,3);
	i(2,3):=row;
	end loop;
	for counter in 3 downto 1 loop
	row :=i(3,0);
	i(3,0):=i(3,1);
	i(3,1):=i(3,2);
	i(3,2):=i(3,3);
	i(3,3):=row;
	end loop;
		--MixColumns
		temp3:=i;
	for c in 0 to 3 loop
		s := i(0,c) mod 16;
		t := i(0,c) / 16;
		u := i(1,c) mod 16;
		v := i(1,c) / 16;
		w := i(2,c) mod 16;
		x := i(2,c) / 16;
		y := i(3,c) mod 16;
		z := i(3,c) / 16;
		i(0,c) := to_integer(((to_unsigned(mul2(t,s),8)) xor (to_unsigned(mul3(v,u),8)) xor (to_unsigned(temp3(2,c),8)) xor (to_unsigned(temp3(3,c),8))));
		i(1,c) := to_integer(((to_unsigned(temp3(0,c),8)) xor (to_unsigned(mul2(v,u),8)) xor (to_unsigned(mul3(x,w),8)) xor (to_unsigned(temp3(3,c),8))));
		i(2,c) := to_integer(((to_unsigned(temp3(0,c),8)) xor (to_unsigned(temp3(1,c),8)) xor (to_unsigned(mul2(x,w),8)) xor (to_unsigned(mul3(z,y),8))));
		i(3,c) := to_integer(((to_unsigned(mul3(t,s),8)) xor (to_unsigned(temp3(1,c),8)) xor (to_unsigned(temp3(2,c),8)) xor (to_unsigned(mul2(z,y),8))));	
		end loop;
	--AddRoundKey
			i(0,0):= to_integer(((to_unsigned(i(0,0),8)) xor (to_unsigned(round3(0,0),8))));
			i(1,0):= to_integer(((to_unsigned(i(1,0),8)) xor (to_unsigned(round3(1,0),8))));
			i(2,0):= to_integer(((to_unsigned(i(2,0),8)) xor (to_unsigned(round3(2,0),8))));
			i(3,0):= to_integer(((to_unsigned(i(3,0),8)) xor (to_unsigned(round3(3,0),8))));
			i(0,1):= to_integer(((to_unsigned(i(0,1),8)) xor (to_unsigned(round3(0,1),8))));
			i(1,1):= to_integer(((to_unsigned(i(1,1),8)) xor (to_unsigned(round3(1,1),8))));
			i(2,1):= to_integer(((to_unsigned(i(2,1),8)) xor (to_unsigned(round3(2,1),8))));
			i(3,1):= to_integer(((to_unsigned(i(3,1),8)) xor (to_unsigned(round3(3,1),8))));
			i(0,2):= to_integer(((to_unsigned(i(0,2),8)) xor (to_unsigned(round3(0,2),8))));
			i(1,2):= to_integer(((to_unsigned(i(1,2),8)) xor (to_unsigned(round3(1,2),8))));
			i(2,2):= to_integer(((to_unsigned(i(2,2),8)) xor (to_unsigned(round3(2,2),8))));
			i(3,2):= to_integer(((to_unsigned(i(3,2),8)) xor (to_unsigned(round3(3,2),8))));
			i(0,3):= to_integer(((to_unsigned(i(0,3),8)) xor (to_unsigned(round3(0,3),8))));
			i(1,3):= to_integer(((to_unsigned(i(1,3),8)) xor (to_unsigned(round3(1,3),8))));
			i(2,3):= to_integer(((to_unsigned(i(2,3),8)) xor (to_unsigned(round3(2,3),8))));
			i(3,3):= to_integer(((to_unsigned(i(3,3),8)) xor (to_unsigned(round3(3,3),8))));			
--round 4
--SubBytes
	for counter in 3 downto 0 loop
		for counter2 in 3 downto 0 loop
			a := i(counter,counter2) / 16;
			b := i(counter,counter2) mod 16;
			i(counter,counter2):= s_box_substitution(a,b);
		end loop;
	end loop;
	--ShiftRows
	row :=i(1,0);
	i(1,0):=i(1,1);
	i(1,1):=i(1,2);
	i(1,2):=i(1,3);
	i(1,3):=row;
	for counter in 2 downto 1 loop
	row :=i(2,0);
	i(2,0):=i(2,1);
	i(2,1):=i(2,2);
	i(2,2):=i(2,3);
	i(2,3):=row;
	end loop;
	for counter in 3 downto 1 loop
	row :=i(3,0);
	i(3,0):=i(3,1);
	i(3,1):=i(3,2);
	i(3,2):=i(3,3);
	i(3,3):=row;
	end loop;
		--MixColumns
		temp3:=i;
	for c in 0 to 3 loop
		s := i(0,c) mod 16;
		t := i(0,c) / 16;
		u := i(1,c) mod 16;
		v := i(1,c) / 16;
		w := i(2,c) mod 16;
		x := i(2,c) / 16;
		y := i(3,c) mod 16;
		z := i(3,c) / 16;
		i(0,c) := to_integer(((to_unsigned(mul2(t,s),8)) xor (to_unsigned(mul3(v,u),8)) xor (to_unsigned(temp3(2,c),8)) xor (to_unsigned(temp3(3,c),8))));
		i(1,c) := to_integer(((to_unsigned(temp3(0,c),8)) xor (to_unsigned(mul2(v,u),8)) xor (to_unsigned(mul3(x,w),8)) xor (to_unsigned(temp3(3,c),8))));
		i(2,c) := to_integer(((to_unsigned(temp3(0,c),8)) xor (to_unsigned(temp3(1,c),8)) xor (to_unsigned(mul2(x,w),8)) xor (to_unsigned(mul3(z,y),8))));
		i(3,c) := to_integer(((to_unsigned(mul3(t,s),8)) xor (to_unsigned(temp3(1,c),8)) xor (to_unsigned(temp3(2,c),8)) xor (to_unsigned(mul2(z,y),8))));	
		end loop;
	--AddRoundKey
			i(0,0):= to_integer(((to_unsigned(i(0,0),8)) xor (to_unsigned(round4(0,0),8))));
			i(1,0):= to_integer(((to_unsigned(i(1,0),8)) xor (to_unsigned(round4(1,0),8))));
			i(2,0):= to_integer(((to_unsigned(i(2,0),8)) xor (to_unsigned(round4(2,0),8))));
			i(3,0):= to_integer(((to_unsigned(i(3,0),8)) xor (to_unsigned(round4(3,0),8))));
			i(0,1):= to_integer(((to_unsigned(i(0,1),8)) xor (to_unsigned(round4(0,1),8))));
			i(1,1):= to_integer(((to_unsigned(i(1,1),8)) xor (to_unsigned(round4(1,1),8))));
			i(2,1):= to_integer(((to_unsigned(i(2,1),8)) xor (to_unsigned(round4(2,1),8))));
			i(3,1):= to_integer(((to_unsigned(i(3,1),8)) xor (to_unsigned(round4(3,1),8))));
			i(0,2):= to_integer(((to_unsigned(i(0,2),8)) xor (to_unsigned(round4(0,2),8))));
			i(1,2):= to_integer(((to_unsigned(i(1,2),8)) xor (to_unsigned(round4(1,2),8))));
			i(2,2):= to_integer(((to_unsigned(i(2,2),8)) xor (to_unsigned(round4(2,2),8))));
			i(3,2):= to_integer(((to_unsigned(i(3,2),8)) xor (to_unsigned(round4(3,2),8))));
			i(0,3):= to_integer(((to_unsigned(i(0,3),8)) xor (to_unsigned(round4(0,3),8))));
			i(1,3):= to_integer(((to_unsigned(i(1,3),8)) xor (to_unsigned(round4(1,3),8))));
			i(2,3):= to_integer(((to_unsigned(i(2,3),8)) xor (to_unsigned(round4(2,3),8))));
			i(3,3):= to_integer(((to_unsigned(i(3,3),8)) xor (to_unsigned(round4(3,3),8))));
--round 5
--SubBytes
	for counter in 3 downto 0 loop
		for counter2 in 3 downto 0 loop
			a := i(counter,counter2) / 16;
			b := i(counter,counter2) mod 16;
			i(counter,counter2):= s_box_substitution(a,b);
		end loop;
	end loop;
	--ShiftRows
	row :=i(1,0);
	i(1,0):=i(1,1);
	i(1,1):=i(1,2);
	i(1,2):=i(1,3);
	i(1,3):=row;
	for counter in 2 downto 1 loop
	row :=i(2,0);
	i(2,0):=i(2,1);
	i(2,1):=i(2,2);
	i(2,2):=i(2,3);
	i(2,3):=row;
	end loop;
	for counter in 3 downto 1 loop
	row :=i(3,0);
	i(3,0):=i(3,1);
	i(3,1):=i(3,2);
	i(3,2):=i(3,3);
	i(3,3):=row;
	end loop;
		--MixColumns
		temp3:=i;
	for c in 0 to 3 loop
		s := i(0,c) mod 16;
		t := i(0,c) / 16;
		u := i(1,c) mod 16;
		v := i(1,c) / 16;
		w := i(2,c) mod 16;
		x := i(2,c) / 16;
		y := i(3,c) mod 16;
		z := i(3,c) / 16;
		i(0,c) := to_integer(((to_unsigned(mul2(t,s),8)) xor (to_unsigned(mul3(v,u),8)) xor (to_unsigned(temp3(2,c),8)) xor (to_unsigned(temp3(3,c),8))));
		i(1,c) := to_integer(((to_unsigned(temp3(0,c),8)) xor (to_unsigned(mul2(v,u),8)) xor (to_unsigned(mul3(x,w),8)) xor (to_unsigned(temp3(3,c),8))));
		i(2,c) := to_integer(((to_unsigned(temp3(0,c),8)) xor (to_unsigned(temp3(1,c),8)) xor (to_unsigned(mul2(x,w),8)) xor (to_unsigned(mul3(z,y),8))));
		i(3,c) := to_integer(((to_unsigned(mul3(t,s),8)) xor (to_unsigned(temp3(1,c),8)) xor (to_unsigned(temp3(2,c),8)) xor (to_unsigned(mul2(z,y),8))));	
		end loop;
	--AddRoundKey
			i(0,0):= to_integer(((to_unsigned(i(0,0),8)) xor (to_unsigned(round5(0,0),8))));
			i(1,0):= to_integer(((to_unsigned(i(1,0),8)) xor (to_unsigned(round5(1,0),8))));
			i(2,0):= to_integer(((to_unsigned(i(2,0),8)) xor (to_unsigned(round5(2,0),8))));
			i(3,0):= to_integer(((to_unsigned(i(3,0),8)) xor (to_unsigned(round5(3,0),8))));
			i(0,1):= to_integer(((to_unsigned(i(0,1),8)) xor (to_unsigned(round5(0,1),8))));
			i(1,1):= to_integer(((to_unsigned(i(1,1),8)) xor (to_unsigned(round5(1,1),8))));
			i(2,1):= to_integer(((to_unsigned(i(2,1),8)) xor (to_unsigned(round5(2,1),8))));
			i(3,1):= to_integer(((to_unsigned(i(3,1),8)) xor (to_unsigned(round5(3,1),8))));
			i(0,2):= to_integer(((to_unsigned(i(0,2),8)) xor (to_unsigned(round5(0,2),8))));
			i(1,2):= to_integer(((to_unsigned(i(1,2),8)) xor (to_unsigned(round5(1,2),8))));
			i(2,2):= to_integer(((to_unsigned(i(2,2),8)) xor (to_unsigned(round5(2,2),8))));
			i(3,2):= to_integer(((to_unsigned(i(3,2),8)) xor (to_unsigned(round5(3,2),8))));
			i(0,3):= to_integer(((to_unsigned(i(0,3),8)) xor (to_unsigned(round5(0,3),8))));
			i(1,3):= to_integer(((to_unsigned(i(1,3),8)) xor (to_unsigned(round5(1,3),8))));
			i(2,3):= to_integer(((to_unsigned(i(2,3),8)) xor (to_unsigned(round5(2,3),8))));
			i(3,3):= to_integer(((to_unsigned(i(3,3),8)) xor (to_unsigned(round5(3,3),8))));
--round 6
--SubBytes
	for counter in 3 downto 0 loop
		for counter2 in 3 downto 0 loop
			a := i(counter,counter2) / 16;
			b := i(counter,counter2) mod 16;
			i(counter,counter2):= s_box_substitution(a,b);
		end loop;
	end loop;
	--ShiftRows
	row :=i(1,0);
	i(1,0):=i(1,1);
	i(1,1):=i(1,2);
	i(1,2):=i(1,3);
	i(1,3):=row;
	for counter in 2 downto 1 loop
	row :=i(2,0);
	i(2,0):=i(2,1);
	i(2,1):=i(2,2);
	i(2,2):=i(2,3);
	i(2,3):=row;
	end loop;
	for counter in 3 downto 1 loop
	row :=i(3,0);
	i(3,0):=i(3,1);
	i(3,1):=i(3,2);
	i(3,2):=i(3,3);
	i(3,3):=row;
	end loop;
		--MixColumns
		temp3:=i;
	for c in 0 to 3 loop
		s := i(0,c) mod 16;
		t := i(0,c) / 16;
		u := i(1,c) mod 16;
		v := i(1,c) / 16;
		w := i(2,c) mod 16;
		x := i(2,c) / 16;
		y := i(3,c) mod 16;
		z := i(3,c) / 16;
		i(0,c) := to_integer(((to_unsigned(mul2(t,s),8)) xor (to_unsigned(mul3(v,u),8)) xor (to_unsigned(temp3(2,c),8)) xor (to_unsigned(temp3(3,c),8))));
		i(1,c) := to_integer(((to_unsigned(temp3(0,c),8)) xor (to_unsigned(mul2(v,u),8)) xor (to_unsigned(mul3(x,w),8)) xor (to_unsigned(temp3(3,c),8))));
		i(2,c) := to_integer(((to_unsigned(temp3(0,c),8)) xor (to_unsigned(temp3(1,c),8)) xor (to_unsigned(mul2(x,w),8)) xor (to_unsigned(mul3(z,y),8))));
		i(3,c) := to_integer(((to_unsigned(mul3(t,s),8)) xor (to_unsigned(temp3(1,c),8)) xor (to_unsigned(temp3(2,c),8)) xor (to_unsigned(mul2(z,y),8))));	
		end loop;
	--AddRoundKey
			i(0,0):= to_integer(((to_unsigned(i(0,0),8)) xor (to_unsigned(round6(0,0),8))));
			i(1,0):= to_integer(((to_unsigned(i(1,0),8)) xor (to_unsigned(round6(1,0),8))));
			i(2,0):= to_integer(((to_unsigned(i(2,0),8)) xor (to_unsigned(round6(2,0),8))));
			i(3,0):= to_integer(((to_unsigned(i(3,0),8)) xor (to_unsigned(round6(3,0),8))));
			i(0,1):= to_integer(((to_unsigned(i(0,1),8)) xor (to_unsigned(round6(0,1),8))));
			i(1,1):= to_integer(((to_unsigned(i(1,1),8)) xor (to_unsigned(round6(1,1),8))));
			i(2,1):= to_integer(((to_unsigned(i(2,1),8)) xor (to_unsigned(round6(2,1),8))));
			i(3,1):= to_integer(((to_unsigned(i(3,1),8)) xor (to_unsigned(round6(3,1),8))));
			i(0,2):= to_integer(((to_unsigned(i(0,2),8)) xor (to_unsigned(round6(0,2),8))));
			i(1,2):= to_integer(((to_unsigned(i(1,2),8)) xor (to_unsigned(round6(1,2),8))));
			i(2,2):= to_integer(((to_unsigned(i(2,2),8)) xor (to_unsigned(round6(2,2),8))));
			i(3,2):= to_integer(((to_unsigned(i(3,2),8)) xor (to_unsigned(round6(3,2),8))));
			i(0,3):= to_integer(((to_unsigned(i(0,3),8)) xor (to_unsigned(round6(0,3),8))));
			i(1,3):= to_integer(((to_unsigned(i(1,3),8)) xor (to_unsigned(round6(1,3),8))));
			i(2,3):= to_integer(((to_unsigned(i(2,3),8)) xor (to_unsigned(round6(2,3),8))));
			i(3,3):= to_integer(((to_unsigned(i(3,3),8)) xor (to_unsigned(round6(3,3),8))));
--round 7
--SubBytes
	for counter in 3 downto 0 loop
		for counter2 in 3 downto 0 loop
			a := i(counter,counter2) / 16;
			b := i(counter,counter2) mod 16;
			i(counter,counter2):= s_box_substitution(a,b);
		end loop;
	end loop;
	--ShiftRows
	row :=i(1,0);
	i(1,0):=i(1,1);
	i(1,1):=i(1,2);
	i(1,2):=i(1,3);
	i(1,3):=row;
	for counter in 2 downto 1 loop
	row :=i(2,0);
	i(2,0):=i(2,1);
	i(2,1):=i(2,2);
	i(2,2):=i(2,3);
	i(2,3):=row;
	end loop;
	for counter in 3 downto 1 loop
	row :=i(3,0);
	i(3,0):=i(3,1);
	i(3,1):=i(3,2);
	i(3,2):=i(3,3);
	i(3,3):=row;
	end loop;
		--MixColumns
		temp3:=i;
	for c in 0 to 3 loop
		s := i(0,c) mod 16;
		t := i(0,c) / 16;
		u := i(1,c) mod 16;
		v := i(1,c) / 16;
		w := i(2,c) mod 16;
		x := i(2,c) / 16;
		y := i(3,c) mod 16;
		z := i(3,c) / 16;
		i(0,c) := to_integer(((to_unsigned(mul2(t,s),8)) xor (to_unsigned(mul3(v,u),8)) xor (to_unsigned(temp3(2,c),8)) xor (to_unsigned(temp3(3,c),8))));
		i(1,c) := to_integer(((to_unsigned(temp3(0,c),8)) xor (to_unsigned(mul2(v,u),8)) xor (to_unsigned(mul3(x,w),8)) xor (to_unsigned(temp3(3,c),8))));
		i(2,c) := to_integer(((to_unsigned(temp3(0,c),8)) xor (to_unsigned(temp3(1,c),8)) xor (to_unsigned(mul2(x,w),8)) xor (to_unsigned(mul3(z,y),8))));
		i(3,c) := to_integer(((to_unsigned(mul3(t,s),8)) xor (to_unsigned(temp3(1,c),8)) xor (to_unsigned(temp3(2,c),8)) xor (to_unsigned(mul2(z,y),8))));	
		end loop;
	--AddRoundKey
			i(0,0):= to_integer(((to_unsigned(i(0,0),8)) xor (to_unsigned(round7(0,0),8))));
			i(1,0):= to_integer(((to_unsigned(i(1,0),8)) xor (to_unsigned(round7(1,0),8))));
			i(2,0):= to_integer(((to_unsigned(i(2,0),8)) xor (to_unsigned(round7(2,0),8))));
			i(3,0):= to_integer(((to_unsigned(i(3,0),8)) xor (to_unsigned(round7(3,0),8))));
			i(0,1):= to_integer(((to_unsigned(i(0,1),8)) xor (to_unsigned(round7(0,1),8))));
			i(1,1):= to_integer(((to_unsigned(i(1,1),8)) xor (to_unsigned(round7(1,1),8))));
			i(2,1):= to_integer(((to_unsigned(i(2,1),8)) xor (to_unsigned(round7(2,1),8))));
			i(3,1):= to_integer(((to_unsigned(i(3,1),8)) xor (to_unsigned(round7(3,1),8))));
			i(0,2):= to_integer(((to_unsigned(i(0,2),8)) xor (to_unsigned(round7(0,2),8))));
			i(1,2):= to_integer(((to_unsigned(i(1,2),8)) xor (to_unsigned(round7(1,2),8))));
			i(2,2):= to_integer(((to_unsigned(i(2,2),8)) xor (to_unsigned(round7(2,2),8))));
			i(3,2):= to_integer(((to_unsigned(i(3,2),8)) xor (to_unsigned(round7(3,2),8))));
			i(0,3):= to_integer(((to_unsigned(i(0,3),8)) xor (to_unsigned(round7(0,3),8))));
			i(1,3):= to_integer(((to_unsigned(i(1,3),8)) xor (to_unsigned(round7(1,3),8))));
			i(2,3):= to_integer(((to_unsigned(i(2,3),8)) xor (to_unsigned(round7(2,3),8))));
			i(3,3):= to_integer(((to_unsigned(i(3,3),8)) xor (to_unsigned(round7(3,3),8))));
--round 8
--SubBytes
	for counter in 3 downto 0 loop
		for counter2 in 3 downto 0 loop
			a := i(counter,counter2) / 16;
			b := i(counter,counter2) mod 16;
			i(counter,counter2):= s_box_substitution(a,b);
		end loop;
	end loop;
	--ShiftRows
	row :=i(1,0);
	i(1,0):=i(1,1);
	i(1,1):=i(1,2);
	i(1,2):=i(1,3);
	i(1,3):=row;
	for counter in 2 downto 1 loop
	row :=i(2,0);
	i(2,0):=i(2,1);
	i(2,1):=i(2,2);
	i(2,2):=i(2,3);
	i(2,3):=row;
	end loop;
	for counter in 3 downto 1 loop
	row :=i(3,0);
	i(3,0):=i(3,1);
	i(3,1):=i(3,2);
	i(3,2):=i(3,3);
	i(3,3):=row;
	end loop;
		--MixColumns
		temp3:=i;
	for c in 0 to 3 loop
		s := i(0,c) mod 16;
		t := i(0,c) / 16;
		u := i(1,c) mod 16;
		v := i(1,c) / 16;
		w := i(2,c) mod 16;
		x := i(2,c) / 16;
		y := i(3,c) mod 16;
		z := i(3,c) / 16;
		i(0,c) := to_integer(((to_unsigned(mul2(t,s),8)) xor (to_unsigned(mul3(v,u),8)) xor (to_unsigned(temp3(2,c),8)) xor (to_unsigned(temp3(3,c),8))));
		i(1,c) := to_integer(((to_unsigned(temp3(0,c),8)) xor (to_unsigned(mul2(v,u),8)) xor (to_unsigned(mul3(x,w),8)) xor (to_unsigned(temp3(3,c),8))));
		i(2,c) := to_integer(((to_unsigned(temp3(0,c),8)) xor (to_unsigned(temp3(1,c),8)) xor (to_unsigned(mul2(x,w),8)) xor (to_unsigned(mul3(z,y),8))));
		i(3,c) := to_integer(((to_unsigned(mul3(t,s),8)) xor (to_unsigned(temp3(1,c),8)) xor (to_unsigned(temp3(2,c),8)) xor (to_unsigned(mul2(z,y),8))));	
		end loop;
	--AddRoundKey
			i(0,0):= to_integer(((to_unsigned(i(0,0),8)) xor (to_unsigned(round8(0,0),8))));
			i(1,0):= to_integer(((to_unsigned(i(1,0),8)) xor (to_unsigned(round8(1,0),8))));
			i(2,0):= to_integer(((to_unsigned(i(2,0),8)) xor (to_unsigned(round8(2,0),8))));
			i(3,0):= to_integer(((to_unsigned(i(3,0),8)) xor (to_unsigned(round8(3,0),8))));
			i(0,1):= to_integer(((to_unsigned(i(0,1),8)) xor (to_unsigned(round8(0,1),8))));
			i(1,1):= to_integer(((to_unsigned(i(1,1),8)) xor (to_unsigned(round8(1,1),8))));
			i(2,1):= to_integer(((to_unsigned(i(2,1),8)) xor (to_unsigned(round8(2,1),8))));
			i(3,1):= to_integer(((to_unsigned(i(3,1),8)) xor (to_unsigned(round8(3,1),8))));
			i(0,2):= to_integer(((to_unsigned(i(0,2),8)) xor (to_unsigned(round8(0,2),8))));
			i(1,2):= to_integer(((to_unsigned(i(1,2),8)) xor (to_unsigned(round8(1,2),8))));
			i(2,2):= to_integer(((to_unsigned(i(2,2),8)) xor (to_unsigned(round8(2,2),8))));
			i(3,2):= to_integer(((to_unsigned(i(3,2),8)) xor (to_unsigned(round8(3,2),8))));
			i(0,3):= to_integer(((to_unsigned(i(0,3),8)) xor (to_unsigned(round8(0,3),8))));
			i(1,3):= to_integer(((to_unsigned(i(1,3),8)) xor (to_unsigned(round8(1,3),8))));
			i(2,3):= to_integer(((to_unsigned(i(2,3),8)) xor (to_unsigned(round8(2,3),8))));
			i(3,3):= to_integer(((to_unsigned(i(3,3),8)) xor (to_unsigned(round8(3,3),8))));
--round 9
--SubBytes
	for counter in 3 downto 0 loop
		for counter2 in 3 downto 0 loop
			a := i(counter,counter2) / 16;
			b := i(counter,counter2) mod 16;
			i(counter,counter2):= s_box_substitution(a,b);
		end loop;
	end loop;
	--ShiftRows
	row :=i(1,0);
	i(1,0):=i(1,1);
	i(1,1):=i(1,2);
	i(1,2):=i(1,3);
	i(1,3):=row;
	for counter in 2 downto 1 loop
	row :=i(2,0);
	i(2,0):=i(2,1);
	i(2,1):=i(2,2);
	i(2,2):=i(2,3);
	i(2,3):=row;
	end loop;
	for counter in 3 downto 1 loop
	row :=i(3,0);
	i(3,0):=i(3,1);
	i(3,1):=i(3,2);
	i(3,2):=i(3,3);
	i(3,3):=row;
	end loop;
		--MixColumns
		temp3:=i;
	for c in 0 to 3 loop
		s := i(0,c) mod 16;
		t := i(0,c) / 16;
		u := i(1,c) mod 16;
		v := i(1,c) / 16;
		w := i(2,c) mod 16;
		x := i(2,c) / 16;
		y := i(3,c) mod 16;
		z := i(3,c) / 16;
		i(0,c) := to_integer(((to_unsigned(mul2(t,s),8)) xor (to_unsigned(mul3(v,u),8)) xor (to_unsigned(temp3(2,c),8)) xor (to_unsigned(temp3(3,c),8))));
		i(1,c) := to_integer(((to_unsigned(temp3(0,c),8)) xor (to_unsigned(mul2(v,u),8)) xor (to_unsigned(mul3(x,w),8)) xor (to_unsigned(temp3(3,c),8))));
		i(2,c) := to_integer(((to_unsigned(temp3(0,c),8)) xor (to_unsigned(temp3(1,c),8)) xor (to_unsigned(mul2(x,w),8)) xor (to_unsigned(mul3(z,y),8))));
		i(3,c) := to_integer(((to_unsigned(mul3(t,s),8)) xor (to_unsigned(temp3(1,c),8)) xor (to_unsigned(temp3(2,c),8)) xor (to_unsigned(mul2(z,y),8))));	
		end loop;
	--AddRoundKey
			i(0,0):= to_integer(((to_unsigned(i(0,0),8)) xor (to_unsigned(round9(0,0),8))));
			i(1,0):= to_integer(((to_unsigned(i(1,0),8)) xor (to_unsigned(round9(1,0),8))));
			i(2,0):= to_integer(((to_unsigned(i(2,0),8)) xor (to_unsigned(round9(2,0),8))));
			i(3,0):= to_integer(((to_unsigned(i(3,0),8)) xor (to_unsigned(round9(3,0),8))));
			i(0,1):= to_integer(((to_unsigned(i(0,1),8)) xor (to_unsigned(round9(0,1),8))));
			i(1,1):= to_integer(((to_unsigned(i(1,1),8)) xor (to_unsigned(round9(1,1),8))));
			i(2,1):= to_integer(((to_unsigned(i(2,1),8)) xor (to_unsigned(round9(2,1),8))));
			i(3,1):= to_integer(((to_unsigned(i(3,1),8)) xor (to_unsigned(round9(3,1),8))));
			i(0,2):= to_integer(((to_unsigned(i(0,2),8)) xor (to_unsigned(round9(0,2),8))));
			i(1,2):= to_integer(((to_unsigned(i(1,2),8)) xor (to_unsigned(round9(1,2),8))));
			i(2,2):= to_integer(((to_unsigned(i(2,2),8)) xor (to_unsigned(round9(2,2),8))));
			i(3,2):= to_integer(((to_unsigned(i(3,2),8)) xor (to_unsigned(round9(3,2),8))));
			i(0,3):= to_integer(((to_unsigned(i(0,3),8)) xor (to_unsigned(round9(0,3),8))));
			i(1,3):= to_integer(((to_unsigned(i(1,3),8)) xor (to_unsigned(round9(1,3),8))));
			i(2,3):= to_integer(((to_unsigned(i(2,3),8)) xor (to_unsigned(round9(2,3),8))));
			i(3,3):= to_integer(((to_unsigned(i(3,3),8)) xor (to_unsigned(round9(3,3),8))));
--round 10
--SubBytes
	for counter in 3 downto 0 loop
		for counter2 in 3 downto 0 loop
			a := i(counter,counter2) / 16;
			b := i(counter,counter2) mod 16;
			i(counter,counter2):= s_box_substitution(a,b);
		end loop;
	end loop;
	--ShiftRows
	row :=i(1,0);
	i(1,0):=i(1,1);
	i(1,1):=i(1,2);
	i(1,2):=i(1,3);
	i(1,3):=row;
	for counter in 2 downto 1 loop
	row :=i(2,0);
	i(2,0):=i(2,1);
	i(2,1):=i(2,2);
	i(2,2):=i(2,3);
	i(2,3):=row;
	end loop;
	for counter in 3 downto 1 loop
	row :=i(3,0);
	i(3,0):=i(3,1);
	i(3,1):=i(3,2);
	i(3,2):=i(3,3);
	i(3,3):=row;
	end loop;
	--AddRoundKey
			i(0,0):= to_integer(((to_unsigned(i(0,0),8)) xor (to_unsigned(round10(0,0),8))));
			i(1,0):= to_integer(((to_unsigned(i(1,0),8)) xor (to_unsigned(round10(1,0),8))));
			i(2,0):= to_integer(((to_unsigned(i(2,0),8)) xor (to_unsigned(round10(2,0),8))));
			i(3,0):= to_integer(((to_unsigned(i(3,0),8)) xor (to_unsigned(round10(3,0),8))));
			i(0,1):= to_integer(((to_unsigned(i(0,1),8)) xor (to_unsigned(round10(0,1),8))));
			i(1,1):= to_integer(((to_unsigned(i(1,1),8)) xor (to_unsigned(round10(1,1),8))));
			i(2,1):= to_integer(((to_unsigned(i(2,1),8)) xor (to_unsigned(round10(2,1),8))));
			i(3,1):= to_integer(((to_unsigned(i(3,1),8)) xor (to_unsigned(round10(3,1),8))));
			i(0,2):= to_integer(((to_unsigned(i(0,2),8)) xor (to_unsigned(round10(0,2),8))));
			i(1,2):= to_integer(((to_unsigned(i(1,2),8)) xor (to_unsigned(round10(1,2),8))));
			i(2,2):= to_integer(((to_unsigned(i(2,2),8)) xor (to_unsigned(round10(2,2),8))));
			i(3,2):= to_integer(((to_unsigned(i(3,2),8)) xor (to_unsigned(round10(3,2),8))));
			i(0,3):= to_integer(((to_unsigned(i(0,3),8)) xor (to_unsigned(round10(0,3),8))));
			i(1,3):= to_integer(((to_unsigned(i(1,3),8)) xor (to_unsigned(round10(1,3),8))));
			i(2,3):= to_integer(((to_unsigned(i(2,3),8)) xor (to_unsigned(round10(2,3),8))));
			i(3,3):= to_integer(((to_unsigned(i(3,3),8)) xor (to_unsigned(round10(3,3),8))));
			
output_signal<=std_logic_vector(to_unsigned(i(3,3),8));			
end process;
output<=output_signal;
end Behavioral;

