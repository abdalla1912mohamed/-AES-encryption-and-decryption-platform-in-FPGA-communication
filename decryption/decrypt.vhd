----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:43:49 12/10/2019 
-- Design Name: 
-- Module Name:    decrypt - Behavioral 
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

entity decrypt is
Port(
output1: out std_logic_vector(7 downto 0);
switch: in std_logic);
end decrypt;

architecture Behavioral of decrypt is
signal output_signal1:std_logic_vector(7 downto 0);
signal s_box_substitution: table;
signal s_box_substitution_inverse: table;
signal Rcon: table2;
signal mul9: table :=(
(0, 9, 18, 27, 36, 45, 54, 63, 72, 65, 90, 83, 108, 101, 126, 119), 
(144, 153, 130, 139, 180, 189, 166, 175, 216, 209, 202, 195, 252, 245, 238, 231), 
(59, 50, 41, 32, 31, 22, 13, 4, 115, 122, 97, 104, 87, 94, 69, 76), 
(171, 162, 185, 176, 143, 134, 157, 148, 227, 234, 241, 248, 199, 206, 213, 220), 
(118, 127, 100, 109, 82, 91, 64, 73, 62, 55, 44, 37, 26, 19, 8, 1), 
(230, 239, 244, 253, 194, 203, 208, 217, 174, 167, 188, 181, 138, 131, 152, 145), 
(77, 68, 95, 86, 105, 96, 123, 114, 5, 12, 23, 30, 33, 40, 51, 58), 
(221, 212, 207, 198, 249, 240, 235, 226, 149, 156, 135, 142, 177, 184, 163, 170), 
(236, 229, 254, 247, 200, 193, 218, 211, 164, 173, 182, 191, 128, 137, 146, 155), 
(124, 117, 110, 103, 88, 81, 74, 67, 52, 61, 38, 47, 16, 25, 2, 11), 
(215, 222, 197, 204, 243, 250, 225, 232, 159, 150, 141, 132, 187, 178, 169, 160), 
(71, 78, 85, 92, 99, 106, 113, 120, 15, 6, 29, 20, 43, 34, 57, 48), 
(154, 147, 136, 129, 190, 183, 172, 165, 210, 219, 192, 201, 246, 255, 228, 237), 
(10, 3, 24, 17, 46, 39, 60, 53, 66, 75, 80, 89, 102, 111, 116, 125), 
(161, 168, 179, 186, 133, 140, 151, 158, 233, 224, 251, 242, 205, 196, 223, 214), 
(49, 56, 35, 42, 21, 28, 7, 14, 121, 112, 107, 98, 93, 84, 79, 70));
signal mul11: table :=(
(0, 11, 22, 29, 44, 39, 58, 49, 88, 83, 78, 69, 116, 127, 98, 105), 
(176, 187, 166, 173, 156, 151, 138, 129, 232, 227, 254, 245, 196, 207, 210, 217), 
(123, 112, 109, 102, 87, 92, 65, 74, 35, 40, 53, 62, 15, 4, 25, 18), 
(203, 192, 221, 214, 231, 236, 241, 250, 147, 152, 133, 142, 191, 180, 169, 162), 
(246, 253, 224, 235, 218, 209, 204, 199, 174, 165, 184, 179, 130, 137, 148, 159), 
(70, 77, 80, 91, 106, 97, 124, 119, 30, 21, 8, 3, 50, 57, 36, 47), 
(141, 134, 155, 144, 161, 170, 183, 188, 213, 222, 195, 200, 249, 242, 239, 228), 
(61, 54, 43, 32, 17, 26, 7, 12, 101, 110, 115, 120, 73, 66, 95, 84), 
(247, 252, 225, 234, 219, 208, 205, 198, 175, 164, 185, 178, 131, 136, 149, 158), 
(71, 76, 81, 90, 107, 96, 125, 118, 31, 20, 9, 2, 51, 56, 37, 46), 
(140, 135, 154, 145, 160, 171, 182, 189, 212, 223, 194, 201, 248, 243, 238, 229), 
(60, 55, 42, 33, 16, 27, 6, 13, 100, 111, 114, 121, 72, 67, 94, 85), 
(1, 10, 23, 28, 45, 38, 59, 48, 89, 82, 79, 68, 117, 126, 99, 104), 
(177, 186, 167, 172, 157, 150, 139, 128, 233, 226, 255, 244, 197, 206, 211, 216), 
(122, 113, 108, 103, 86, 93, 64, 75, 34, 41, 52, 63, 14, 5, 24, 19), 
(202, 193, 220, 215, 230, 237, 240, 251, 146, 153, 132, 143, 190, 181, 168, 163));
signal mul13: table :=(
(0, 13, 26, 23, 52, 57, 46, 35, 104, 101, 114, 127, 92, 81, 70, 75), 
(208, 221, 202, 199, 228, 233, 254, 243, 184, 181, 162, 175, 140, 129, 150, 155), 
(187, 182, 161, 172, 143, 130, 149, 152, 211, 222, 201, 196, 231, 234, 253, 240), 
(107, 102, 113, 124, 95, 82, 69, 72, 3, 14, 25, 20, 55, 58, 45, 32), 
(109, 96, 119, 122, 89, 84, 67, 78, 5, 8, 31, 18, 49, 60, 43, 38), 
(189, 176, 167, 170, 137, 132, 147, 158, 213, 216, 207, 194, 225, 236, 251, 246), 
(214, 219, 204, 193, 226, 239, 248, 245, 190, 179, 164, 169, 138, 135, 144, 157), 
(6, 11, 28, 17, 50, 63, 40, 37, 110, 99, 116, 121, 90, 87, 64, 77), 
(218, 215, 192, 205, 238, 227, 244, 249, 178, 191, 168, 165, 134, 139, 156, 145), 
(10, 7, 16, 29, 62, 51, 36, 41, 98, 111, 120, 117, 86, 91, 76, 65), 
(97, 108, 123, 118, 85, 88, 79, 66, 9, 4, 19, 30, 61, 48, 39, 42), 
(177, 188, 171, 166, 133, 136, 159, 146, 217, 212, 195, 206, 237, 224, 247, 250), 
(183, 186, 173, 160, 131, 142, 153, 148, 223, 210, 197, 200, 235, 230, 241, 252), 
(103, 106, 125, 112, 83, 94, 73, 68, 15, 2, 21, 24, 59, 54, 33, 44), 
(12, 1, 22, 27, 56, 53, 34, 47, 100, 105, 126, 115, 80, 93, 74, 71), 
(220, 209, 198, 203, 232, 229, 242, 255, 180, 185, 174, 163, 128, 141, 154, 151));
signal mul14: table :=(
(0, 14, 28, 18, 56, 54, 36, 42, 112, 126, 108, 98, 72, 70, 84, 90), 
(224, 238, 252, 242, 216, 214, 196, 202, 144, 158, 140, 130, 168, 166, 180, 186), 
(219, 213, 199, 201, 227, 237, 255, 241, 171, 165, 183, 185, 147, 157, 143, 129), 
(59, 53, 39, 41, 3, 13, 31, 17, 75, 69, 87, 89, 115, 125, 111, 97), 
(173, 163, 177, 191, 149, 155, 137, 135, 221, 211, 193, 207, 229, 235, 249, 247), 
(77, 67, 81, 95, 117, 123, 105, 103, 61, 51, 33, 47, 5, 11, 25, 23), 
(118, 120, 106, 100, 78, 64, 82, 92, 6, 8, 26, 20, 62, 48, 34, 44), 
(150, 152, 138, 132, 174, 160, 178, 188, 230, 232, 250, 244, 222, 208, 194, 204), 
(65, 79, 93, 83, 121, 119, 101, 107, 49, 63, 45, 35, 9, 7, 21, 27), 
(161, 175, 189, 179, 153, 151, 133, 139, 209, 223, 205, 195, 233, 231, 245, 251), 
(154, 148, 134, 136, 162, 172, 190, 176, 234, 228, 246, 248, 210, 220, 206, 192), 
(122, 116, 102, 104, 66, 76, 94, 80, 10, 4, 22, 24, 50, 60, 46, 32), 
(236, 226, 240, 254, 212, 218, 200, 198, 156, 146, 128, 142, 164, 170, 184, 182), 
(12, 2, 16, 30, 52, 58, 40, 38, 124, 114, 96, 110, 68, 74, 88, 86), 
(55, 57, 43, 37, 15, 1, 19, 29, 71, 73, 91, 85, 127, 113, 99, 109), 
(215, 217, 203, 197, 239, 225, 243, 253, 167, 169, 187, 181, 159, 145, 131, 141));
signal key: matrix;
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
--initializing the s_box_inverse table
s_box_substitution_inverse(0,0)<=82;s_box_substitution_inverse(1,0)<=124;s_box_substitution_inverse(2,0)<=84;s_box_substitution_inverse(3,0)<=08;s_box_substitution_inverse(4,0)<=114;s_box_substitution_inverse(5,0)<=108;s_box_substitution_inverse(6,0)<=144;s_box_substitution_inverse(7,0)<=208;s_box_substitution_inverse(8,0)<=58;s_box_substitution_inverse(9,0)<=150;s_box_substitution_inverse(10,0)<=71;s_box_substitution_inverse(11,0)<=252;s_box_substitution_inverse(12,0)<=31;s_box_substitution_inverse(13,0)<=96;s_box_substitution_inverse(14,0)<=160;s_box_substitution_inverse(15,0)<=23;
s_box_substitution_inverse(0,1)<=094;s_box_substitution_inverse(1,1)<=227;s_box_substitution_inverse(2,1)<=123;s_box_substitution_inverse(3,1)<=46;s_box_substitution_inverse(4,1)<=248;s_box_substitution_inverse(5,1)<=112;s_box_substitution_inverse(6,1)<=216;s_box_substitution_inverse(7,1)<=44;s_box_substitution_inverse(8,1)<=145;s_box_substitution_inverse(9,1)<=172;s_box_substitution_inverse(10,1)<=241;s_box_substitution_inverse(11,1)<=86;s_box_substitution_inverse(12,1)<=221;s_box_substitution_inverse(13,1)<=81;s_box_substitution_inverse(14,1)<=224;s_box_substitution_inverse(15,1)<=43;
s_box_substitution_inverse(0,2)<=106;s_box_substitution_inverse(1,2)<=57;s_box_substitution_inverse(2,2)<=148;s_box_substitution_inverse(3,2)<=161;s_box_substitution_inverse(4,2)<=246;s_box_substitution_inverse(5,2)<=72;s_box_substitution_inverse(6,2)<=171;s_box_substitution_inverse(7,2)<=30;s_box_substitution_inverse(8,2)<=17;s_box_substitution_inverse(9,2)<=116;s_box_substitution_inverse(10,2)<=26;s_box_substitution_inverse(11,2)<=62;s_box_substitution_inverse(12,2)<=168;s_box_substitution_inverse(13,2)<=127;s_box_substitution_inverse(14,2)<=59;s_box_substitution_inverse(15,2)<=04;
s_box_substitution_inverse(0,3)<=213;s_box_substitution_inverse(1,3)<=130;s_box_substitution_inverse(2,3)<=50;s_box_substitution_inverse(3,3)<=102;s_box_substitution_inverse(4,3)<=100;s_box_substitution_inverse(5,3)<=80;s_box_substitution_inverse(6,3)<=00;s_box_substitution_inverse(7,3)<=143;s_box_substitution_inverse(8,3)<=65;s_box_substitution_inverse(9,3)<=34;s_box_substitution_inverse(10,3)<=113;s_box_substitution_inverse(11,3)<=75;s_box_substitution_inverse(12,3)<=51;s_box_substitution_inverse(13,3)<=169;s_box_substitution_inverse(14,3)<=77;s_box_substitution_inverse(15,3)<=126;
s_box_substitution_inverse(0,4)<=48;s_box_substitution_inverse(1,4)<=155;s_box_substitution_inverse(2,4)<=166;s_box_substitution_inverse(3,4)<=40;s_box_substitution_inverse(4,4)<=134;s_box_substitution_inverse(5,4)<=253;s_box_substitution_inverse(6,4)<=140;s_box_substitution_inverse(7,4)<=202;s_box_substitution_inverse(8,4)<=79;s_box_substitution_inverse(9,4)<=231;s_box_substitution_inverse(10,4)<=29;s_box_substitution_inverse(11,4)<=198;s_box_substitution_inverse(12,4)<=136;s_box_substitution_inverse(13,4)<=25;s_box_substitution_inverse(14,4)<=174;s_box_substitution_inverse(15,4)<=186;
s_box_substitution_inverse(0,5)<=54;s_box_substitution_inverse(1,5)<=47;s_box_substitution_inverse(2,5)<=194;s_box_substitution_inverse(3,5)<=217;s_box_substitution_inverse(4,5)<=104;s_box_substitution_inverse(5,5)<=237;s_box_substitution_inverse(6,5)<=188;s_box_substitution_inverse(7,5)<=63;s_box_substitution_inverse(8,5)<=103;s_box_substitution_inverse(9,5)<=173;s_box_substitution_inverse(10,5)<=41;s_box_substitution_inverse(11,5)<=210;s_box_substitution_inverse(12,5)<=07;s_box_substitution_inverse(13,5)<=181;s_box_substitution_inverse(14,5)<=42;s_box_substitution_inverse(15,5)<=119;
s_box_substitution_inverse(0,6)<=165;s_box_substitution_inverse(1,6)<=255;s_box_substitution_inverse(2,6)<=35;s_box_substitution_inverse(3,6)<=36;s_box_substitution_inverse(4,6)<=152;s_box_substitution_inverse(5,6)<=185;s_box_substitution_inverse(6,6)<=211;s_box_substitution_inverse(7,6)<=15;s_box_substitution_inverse(8,6)<=220;s_box_substitution_inverse(9,6)<=53;s_box_substitution_inverse(10,6)<=197;s_box_substitution_inverse(11,6)<=121;s_box_substitution_inverse(12,6)<=199;s_box_substitution_inverse(13,6)<=74;s_box_substitution_inverse(14,6)<=245;s_box_substitution_inverse(15,6)<=214;
s_box_substitution_inverse(0,7)<=56;s_box_substitution_inverse(1,7)<=135;s_box_substitution_inverse(2,7)<=61;s_box_substitution_inverse(3,7)<=178;s_box_substitution_inverse(4,7)<=22;s_box_substitution_inverse(5,7)<=218;s_box_substitution_inverse(6,7)<=10;s_box_substitution_inverse(7,7)<=02;s_box_substitution_inverse(8,7)<=234;s_box_substitution_inverse(9,7)<=133;s_box_substitution_inverse(10,7)<=137;s_box_substitution_inverse(11,7)<=32;s_box_substitution_inverse(12,7)<=49;s_box_substitution_inverse(13,7)<=13;s_box_substitution_inverse(14,7)<=176;s_box_substitution_inverse(15,7)<=38;
s_box_substitution_inverse(0,8)<=191;s_box_substitution_inverse(1,8)<=52;s_box_substitution_inverse(2,8)<=238;s_box_substitution_inverse(3,8)<=118;s_box_substitution_inverse(4,8)<=212;s_box_substitution_inverse(5,8)<=94;s_box_substitution_inverse(6,8)<=247;s_box_substitution_inverse(7,8)<=193;s_box_substitution_inverse(8,8)<=151;s_box_substitution_inverse(9,8)<=226;s_box_substitution_inverse(10,8)<=111;s_box_substitution_inverse(11,8)<=154;s_box_substitution_inverse(12,8)<=177;s_box_substitution_inverse(13,8)<=45;s_box_substitution_inverse(14,8)<=200;s_box_substitution_inverse(15,8)<=225;
s_box_substitution_inverse(0,9)<=64;s_box_substitution_inverse(1,9)<=142;s_box_substitution_inverse(2,9)<=76;s_box_substitution_inverse(3,9)<=91;s_box_substitution_inverse(4,9)<=164;s_box_substitution_inverse(5,9)<=21;s_box_substitution_inverse(6,9)<=228;s_box_substitution_inverse(7,9)<=175;s_box_substitution_inverse(8,9)<=242;s_box_substitution_inverse(9,9)<=249;s_box_substitution_inverse(10,9)<=183;s_box_substitution_inverse(11,9)<=219;s_box_substitution_inverse(12,9)<=18;s_box_substitution_inverse(13,9)<=229;s_box_substitution_inverse(14,9)<=235;s_box_substitution_inverse(15,9)<=105;
s_box_substitution_inverse(0,10)<=163;s_box_substitution_inverse(1,10)<=67;s_box_substitution_inverse(2,10)<=149;s_box_substitution_inverse(3,10)<=162;s_box_substitution_inverse(4,10)<=92;s_box_substitution_inverse(5,10)<=70;s_box_substitution_inverse(6,10)<=88;s_box_substitution_inverse(7,10)<=189;s_box_substitution_inverse(8,10)<=207;s_box_substitution_inverse(9,10)<=55;s_box_substitution_inverse(10,10)<=98;s_box_substitution_inverse(11,10)<=192;s_box_substitution_inverse(12,10)<=16;s_box_substitution_inverse(13,10)<=122;s_box_substitution_inverse(14,10)<=187;s_box_substitution_inverse(15,10)<=20;
s_box_substitution_inverse(0,11)<=158;s_box_substitution_inverse(1,11)<=68;s_box_substitution_inverse(2,11)<=11;s_box_substitution_inverse(3,11)<=73;s_box_substitution_inverse(4,11)<=204;s_box_substitution_inverse(5,11)<=87;s_box_substitution_inverse(6,11)<=05;s_box_substitution_inverse(7,11)<=03;s_box_substitution_inverse(8,11)<=206;s_box_substitution_inverse(9,11)<=232;s_box_substitution_inverse(10,11)<=14;s_box_substitution_inverse(11,11)<=254;s_box_substitution_inverse(12,11)<=89;s_box_substitution_inverse(13,11)<=159;s_box_substitution_inverse(14,11)<=60;s_box_substitution_inverse(15,11)<=99;
s_box_substitution_inverse(0,12)<=129;s_box_substitution_inverse(1,12)<=196;s_box_substitution_inverse(2,12)<=66;s_box_substitution_inverse(3,12)<=109;s_box_substitution_inverse(4,12)<=93;s_box_substitution_inverse(5,12)<=167;s_box_substitution_inverse(6,12)<=184;s_box_substitution_inverse(7,12)<=01;s_box_substitution_inverse(8,12)<=240;s_box_substitution_inverse(9,12)<=28;s_box_substitution_inverse(10,12)<=170;s_box_substitution_inverse(11,12)<=120;s_box_substitution_inverse(12,12)<=39;s_box_substitution_inverse(13,12)<=147;s_box_substitution_inverse(14,12)<=131;s_box_substitution_inverse(15,12)<=85;
s_box_substitution_inverse(0,13)<=243;s_box_substitution_inverse(1,13)<=222;s_box_substitution_inverse(2,13)<=250;s_box_substitution_inverse(3,13)<=139;s_box_substitution_inverse(4,13)<=101;s_box_substitution_inverse(5,13)<=141;s_box_substitution_inverse(6,13)<=179;s_box_substitution_inverse(7,13)<=19;s_box_substitution_inverse(8,13)<=180;s_box_substitution_inverse(9,13)<=117;s_box_substitution_inverse(10,13)<=24;s_box_substitution_inverse(11,13)<=205;s_box_substitution_inverse(12,13)<=128;s_box_substitution_inverse(13,13)<=201;s_box_substitution_inverse(14,13)<=83;s_box_substitution_inverse(15,13)<=33;
s_box_substitution_inverse(0,14)<=215;s_box_substitution_inverse(1,14)<=233;s_box_substitution_inverse(2,14)<=195;s_box_substitution_inverse(3,14)<=209;s_box_substitution_inverse(4,14)<=182;s_box_substitution_inverse(5,14)<=157;s_box_substitution_inverse(6,14)<=69;s_box_substitution_inverse(7,14)<=138;s_box_substitution_inverse(8,14)<=230;s_box_substitution_inverse(9,14)<=223;s_box_substitution_inverse(10,14)<=190;s_box_substitution_inverse(11,14)<=90;s_box_substitution_inverse(12,14)<=236;s_box_substitution_inverse(13,14)<=156;s_box_substitution_inverse(14,14)<=153;s_box_substitution_inverse(15,14)<=12;
s_box_substitution_inverse(0,15)<=251;s_box_substitution_inverse(1,15)<=203;s_box_substitution_inverse(2,15)<=78;s_box_substitution_inverse(3,15)<=37;s_box_substitution_inverse(4,15)<=146;s_box_substitution_inverse(5,15)<=132;s_box_substitution_inverse(6,15)<=06;s_box_substitution_inverse(7,15)<=107;s_box_substitution_inverse(8,15)<=115;s_box_substitution_inverse(9,15)<=110;s_box_substitution_inverse(10,15)<=27;s_box_substitution_inverse(11,15)<=244;s_box_substitution_inverse(12,15)<=95;s_box_substitution_inverse(13,15)<=239;s_box_substitution_inverse(14,15)<=97;s_box_substitution_inverse(15,15)<=125;
--initializing the key "should be random"
key(0,0)<=43;key(0,1)<=40 ;key(0,2)<=171;key(0,3)<=9;key(1,0)<=126;key(1,1)<=174;key(1,2)<=247;key(1,3)<=207;key(2,0)<=21;key(2,1)<=210;key(2,2)<=21;key(2,3)<=79;key(3,0)<=22;key(3,1)<=166;key(3,2)<=136;key(3,3)<=60;
process(switch)
--initializong the input matrix
variable i : matrix;
variable temp: integer;
variable temp1: matrix;
variable temp2: matrix;
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
i:=((57,02,220,25),(37,220,17,106),(132,09,133,11),(29,251,151,50));
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
		round10(3,3):= to_integer((to_unsigned(round9(3,3),8) xor to_unsigned(round10(3,2),8)));
--Starting the 10 rounds
--round 1
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
--ShiftRows
	row :=i(1,3);
	i(1,3):=i(1,2);
	i(1,2):=i(1,1);
	i(1,1):=i(1,0);
	i(1,0):=row;
	for counter in 2 downto 1 loop
	row :=i(2,3);
	i(2,3):=i(2,2);
	i(2,2):=i(2,1);
	i(2,1):=i(2,0);
	i(2,0):=row;
	end loop;
	for counter in 3 downto 1 loop
	row :=i(3,3);
	i(3,3):=i(3,2);
	i(3,2):=i(3,1);
	i(3,1):=i(3,0);
	i(3,0):=row;
	end loop;
--SubBytes
	for counter in 3 downto 0 loop
		for counter2 in 3 downto 0 loop
			a := i(counter,counter2) / 16;
			b := i(counter,counter2) mod 16;
			i(counter,counter2):= s_box_substitution_inverse(a,b);
		end loop;
	end loop;
--Round 2
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
	--MixColumns
	for c in 3 downto 0 loop
		s := i(0,c) mod 16;
		t := i(0,c) / 16;
		u := i(1,c) mod 16;
		v := i(1,c) / 16;
		w := i(2,c) mod 16;
		x := i(2,c) / 16;
		y := i(3,c) mod 16;
		z := i(3,c) / 16;
		i(0,c) := to_integer(((to_unsigned(mul14(t,s),8)) xor (to_unsigned(mul11(v,u),8)) xor (to_unsigned(mul13(x,w),8)) xor (to_unsigned(mul9(z,y),8))));
		i(1,c) := to_integer(((to_unsigned(mul9(t,s),8)) xor (to_unsigned(mul14(v,u),8)) xor (to_unsigned(mul11(x,w),8)) xor (to_unsigned(mul13(z,y),8))));
		i(2,c) := to_integer(((to_unsigned(mul13(t,s),8)) xor (to_unsigned(mul9(v,u),8)) xor (to_unsigned(mul14(x,w),8)) xor (to_unsigned(mul11(z,y),8))));
		i(3,c) := to_integer(((to_unsigned(mul11(t,s),8)) xor (to_unsigned(mul13(v,u),8)) xor (to_unsigned(mul9(x,w),8)) xor (to_unsigned(mul14(z,y),8))));
	end loop;
	--ShiftRows
	row :=i(1,3);
	i(1,3):=i(1,2);
	i(1,2):=i(1,1);
	i(1,1):=i(1,0);
	i(1,0):=row;
	for counter in 2 downto 1 loop
	row :=i(2,3);
	i(2,3):=i(2,2);
	i(2,2):=i(2,1);
	i(2,1):=i(2,0);
	i(2,0):=row;
	end loop;
	for counter in 3 downto 1 loop
	row :=i(3,3);
	i(3,3):=i(3,2);
	i(3,2):=i(3,1);
	i(3,1):=i(3,0);
	i(3,0):=row;
	end loop;
	--SubBytes
	for counter in 3 downto 0 loop
		for counter2 in 3 downto 0 loop
			a := i(counter,counter2) / 16;
			b := i(counter,counter2) mod 16;
			i(counter,counter2):= s_box_substitution_inverse(a,b);
		end loop;
	end loop;
--Round 3
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
	--MixColumns
	for c in 3 downto 0 loop
		s := i(0,c) mod 16;
		t := i(0,c) / 16;
		u := i(1,c) mod 16;
		v := i(1,c) / 16;
		w := i(2,c) mod 16;
		x := i(2,c) / 16;
		y := i(3,c) mod 16;
		z := i(3,c) / 16;
		i(0,c) := to_integer(((to_unsigned(mul14(t,s),8)) xor (to_unsigned(mul11(v,u),8)) xor (to_unsigned(mul13(x,w),8)) xor (to_unsigned(mul9(z,y),8))));
		i(1,c) := to_integer(((to_unsigned(mul9(t,s),8)) xor (to_unsigned(mul14(v,u),8)) xor (to_unsigned(mul11(x,w),8)) xor (to_unsigned(mul13(z,y),8))));
		i(2,c) := to_integer(((to_unsigned(mul13(t,s),8)) xor (to_unsigned(mul9(v,u),8)) xor (to_unsigned(mul14(x,w),8)) xor (to_unsigned(mul11(z,y),8))));
		i(3,c) := to_integer(((to_unsigned(mul11(t,s),8)) xor (to_unsigned(mul13(v,u),8)) xor (to_unsigned(mul9(x,w),8)) xor (to_unsigned(mul14(z,y),8))));
	end loop;
	--ShiftRows
	row :=i(1,3);
	i(1,3):=i(1,2);
	i(1,2):=i(1,1);
	i(1,1):=i(1,0);
	i(1,0):=row;
	for counter in 2 downto 1 loop
	row :=i(2,3);
	i(2,3):=i(2,2);
	i(2,2):=i(2,1);
	i(2,1):=i(2,0);
	i(2,0):=row;
	end loop;
	for counter in 3 downto 1 loop
	row :=i(3,3);
	i(3,3):=i(3,2);
	i(3,2):=i(3,1);
	i(3,1):=i(3,0);
	i(3,0):=row;
	end loop;
	--SubBytes
	for counter in 3 downto 0 loop
		for counter2 in 3 downto 0 loop
			a := i(counter,counter2) / 16;
			b := i(counter,counter2) mod 16;
			i(counter,counter2):= s_box_substitution_inverse(a,b);
		end loop;
	end loop;
	--Round 4
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
	--MixColumns
	for c in 3 downto 0 loop
		s := i(0,c) mod 16;
		t := i(0,c) / 16;
		u := i(1,c) mod 16;
		v := i(1,c) / 16;
		w := i(2,c) mod 16;
		x := i(2,c) / 16;
		y := i(3,c) mod 16;
		z := i(3,c) / 16;
		i(0,c) := to_integer(((to_unsigned(mul14(t,s),8)) xor (to_unsigned(mul11(v,u),8)) xor (to_unsigned(mul13(x,w),8)) xor (to_unsigned(mul9(z,y),8))));
		i(1,c) := to_integer(((to_unsigned(mul9(t,s),8)) xor (to_unsigned(mul14(v,u),8)) xor (to_unsigned(mul11(x,w),8)) xor (to_unsigned(mul13(z,y),8))));
		i(2,c) := to_integer(((to_unsigned(mul13(t,s),8)) xor (to_unsigned(mul9(v,u),8)) xor (to_unsigned(mul14(x,w),8)) xor (to_unsigned(mul11(z,y),8))));
		i(3,c) := to_integer(((to_unsigned(mul11(t,s),8)) xor (to_unsigned(mul13(v,u),8)) xor (to_unsigned(mul9(x,w),8)) xor (to_unsigned(mul14(z,y),8))));
	end loop;
	--ShiftRows
	row :=i(1,3);
	i(1,3):=i(1,2);
	i(1,2):=i(1,1);
	i(1,1):=i(1,0);
	i(1,0):=row;
	for counter in 2 downto 1 loop
	row :=i(2,3);
	i(2,3):=i(2,2);
	i(2,2):=i(2,1);
	i(2,1):=i(2,0);
	i(2,0):=row;
	end loop;
	for counter in 3 downto 1 loop
	row :=i(3,3);
	i(3,3):=i(3,2);
	i(3,2):=i(3,1);
	i(3,1):=i(3,0);
	i(3,0):=row;
	end loop;
	--SubBytes
	for counter in 3 downto 0 loop
		for counter2 in 3 downto 0 loop
			a := i(counter,counter2) / 16;
			b := i(counter,counter2) mod 16;
			i(counter,counter2):= s_box_substitution_inverse(a,b);
		end loop;
	end loop;
--Round 5
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
	--MixColumns
	for c in 3 downto 0 loop
		s := i(0,c) mod 16;
		t := i(0,c) / 16;
		u := i(1,c) mod 16;
		v := i(1,c) / 16;
		w := i(2,c) mod 16;
		x := i(2,c) / 16;
		y := i(3,c) mod 16;
		z := i(3,c) / 16;
		i(0,c) := to_integer(((to_unsigned(mul14(t,s),8)) xor (to_unsigned(mul11(v,u),8)) xor (to_unsigned(mul13(x,w),8)) xor (to_unsigned(mul9(z,y),8))));
		i(1,c) := to_integer(((to_unsigned(mul9(t,s),8)) xor (to_unsigned(mul14(v,u),8)) xor (to_unsigned(mul11(x,w),8)) xor (to_unsigned(mul13(z,y),8))));
		i(2,c) := to_integer(((to_unsigned(mul13(t,s),8)) xor (to_unsigned(mul9(v,u),8)) xor (to_unsigned(mul14(x,w),8)) xor (to_unsigned(mul11(z,y),8))));
		i(3,c) := to_integer(((to_unsigned(mul11(t,s),8)) xor (to_unsigned(mul13(v,u),8)) xor (to_unsigned(mul9(x,w),8)) xor (to_unsigned(mul14(z,y),8))));
	end loop;
	--ShiftRows
	row :=i(1,3);
	i(1,3):=i(1,2);
	i(1,2):=i(1,1);
	i(1,1):=i(1,0);
	i(1,0):=row;
	for counter in 2 downto 1 loop
	row :=i(2,3);
	i(2,3):=i(2,2);
	i(2,2):=i(2,1);
	i(2,1):=i(2,0);
	i(2,0):=row;
	end loop;
	for counter in 3 downto 1 loop
	row :=i(3,3);
	i(3,3):=i(3,2);
	i(3,2):=i(3,1);
	i(3,1):=i(3,0);
	i(3,0):=row;
	end loop;
	--SubBytes
	for counter in 3 downto 0 loop
		for counter2 in 3 downto 0 loop
			a := i(counter,counter2) / 16;
			b := i(counter,counter2) mod 16;
			i(counter,counter2):= s_box_substitution_inverse(a,b);
		end loop;
	end loop;
--Round 6
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
	--MixColumns
	for c in 3 downto 0 loop
		s := i(0,c) mod 16;
		t := i(0,c) / 16;
		u := i(1,c) mod 16;
		v := i(1,c) / 16;
		w := i(2,c) mod 16;
		x := i(2,c) / 16;
		y := i(3,c) mod 16;
		z := i(3,c) / 16;
		i(0,c) := to_integer(((to_unsigned(mul14(t,s),8)) xor (to_unsigned(mul11(v,u),8)) xor (to_unsigned(mul13(x,w),8)) xor (to_unsigned(mul9(z,y),8))));
		i(1,c) := to_integer(((to_unsigned(mul9(t,s),8)) xor (to_unsigned(mul14(v,u),8)) xor (to_unsigned(mul11(x,w),8)) xor (to_unsigned(mul13(z,y),8))));
		i(2,c) := to_integer(((to_unsigned(mul13(t,s),8)) xor (to_unsigned(mul9(v,u),8)) xor (to_unsigned(mul14(x,w),8)) xor (to_unsigned(mul11(z,y),8))));
		i(3,c) := to_integer(((to_unsigned(mul11(t,s),8)) xor (to_unsigned(mul13(v,u),8)) xor (to_unsigned(mul9(x,w),8)) xor (to_unsigned(mul14(z,y),8))));
	end loop;
	--ShiftRows
	row :=i(1,3);
	i(1,3):=i(1,2);
	i(1,2):=i(1,1);
	i(1,1):=i(1,0);
	i(1,0):=row;
	for counter in 2 downto 1 loop
	row :=i(2,3);
	i(2,3):=i(2,2);
	i(2,2):=i(2,1);
	i(2,1):=i(2,0);
	i(2,0):=row;
	end loop;
	for counter in 3 downto 1 loop
	row :=i(3,3);
	i(3,3):=i(3,2);
	i(3,2):=i(3,1);
	i(3,1):=i(3,0);
	i(3,0):=row;
	end loop;
	--SubBytes
	for counter in 3 downto 0 loop
		for counter2 in 3 downto 0 loop
			a := i(counter,counter2) / 16;
			b := i(counter,counter2) mod 16;
			i(counter,counter2):= s_box_substitution_inverse(a,b);
		end loop;
	end loop;
	--Round 7
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
	--MixColumns
	for c in 3 downto 0 loop
		s := i(0,c) mod 16;
		t := i(0,c) / 16;
		u := i(1,c) mod 16;
		v := i(1,c) / 16;
		w := i(2,c) mod 16;
		x := i(2,c) / 16;
		y := i(3,c) mod 16;
		z := i(3,c) / 16;
		i(0,c) := to_integer(((to_unsigned(mul14(t,s),8)) xor (to_unsigned(mul11(v,u),8)) xor (to_unsigned(mul13(x,w),8)) xor (to_unsigned(mul9(z,y),8))));
		i(1,c) := to_integer(((to_unsigned(mul9(t,s),8)) xor (to_unsigned(mul14(v,u),8)) xor (to_unsigned(mul11(x,w),8)) xor (to_unsigned(mul13(z,y),8))));
		i(2,c) := to_integer(((to_unsigned(mul13(t,s),8)) xor (to_unsigned(mul9(v,u),8)) xor (to_unsigned(mul14(x,w),8)) xor (to_unsigned(mul11(z,y),8))));
		i(3,c) := to_integer(((to_unsigned(mul11(t,s),8)) xor (to_unsigned(mul13(v,u),8)) xor (to_unsigned(mul9(x,w),8)) xor (to_unsigned(mul14(z,y),8))));
	end loop;
	--ShiftRows
	row :=i(1,3);
	i(1,3):=i(1,2);
	i(1,2):=i(1,1);
	i(1,1):=i(1,0);
	i(1,0):=row;
	for counter in 2 downto 1 loop
	row :=i(2,3);
	i(2,3):=i(2,2);
	i(2,2):=i(2,1);
	i(2,1):=i(2,0);
	i(2,0):=row;
	end loop;
	for counter in 3 downto 1 loop
	row :=i(3,3);
	i(3,3):=i(3,2);
	i(3,2):=i(3,1);
	i(3,1):=i(3,0);
	i(3,0):=row;
	end loop;
	--SubBytes
	for counter in 3 downto 0 loop
		for counter2 in 3 downto 0 loop
			a := i(counter,counter2) / 16;
			b := i(counter,counter2) mod 16;
			i(counter,counter2):= s_box_substitution_inverse(a,b);
		end loop;
	end loop;
	--Round 8
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
	--MixColumn
	for c in 3 downto 0 loop
		s := i(0,c) mod 16;
		t := i(0,c) / 16;
		u := i(1,c) mod 16;
		v := i(1,c) / 16;
		w := i(2,c) mod 16;
		x := i(2,c) / 16;
		y := i(3,c) mod 16;
		z := i(3,c) / 16;
		i(0,c) := to_integer(((to_unsigned(mul14(t,s),8)) xor (to_unsigned(mul11(v,u),8)) xor (to_unsigned(mul13(x,w),8)) xor (to_unsigned(mul9(z,y),8))));
		i(1,c) := to_integer(((to_unsigned(mul9(t,s),8)) xor (to_unsigned(mul14(v,u),8)) xor (to_unsigned(mul11(x,w),8)) xor (to_unsigned(mul13(z,y),8))));
		i(2,c) := to_integer(((to_unsigned(mul13(t,s),8)) xor (to_unsigned(mul9(v,u),8)) xor (to_unsigned(mul14(x,w),8)) xor (to_unsigned(mul11(z,y),8))));
		i(3,c) := to_integer(((to_unsigned(mul11(t,s),8)) xor (to_unsigned(mul13(v,u),8)) xor (to_unsigned(mul9(x,w),8)) xor (to_unsigned(mul14(z,y),8))));
	end loop;
	--ShiftRows
	row :=i(1,3);
	i(1,3):=i(1,2);
	i(1,2):=i(1,1);
	i(1,1):=i(1,0);
	i(1,0):=row;
	for counter in 2 downto 1 loop
	row :=i(2,3);
	i(2,3):=i(2,2);
	i(2,2):=i(2,1);
	i(2,1):=i(2,0);
	i(2,0):=row;
	end loop;
	for counter in 3 downto 1 loop
	row :=i(3,3);
	i(3,3):=i(3,2);
	i(3,2):=i(3,1);
	i(3,1):=i(3,0);
	i(3,0):=row;
	end loop;
	--SubBytes
	for counter in 3 downto 0 loop
		for counter2 in 3 downto 0 loop
			a := i(counter,counter2) / 16;
			b := i(counter,counter2) mod 16;
			i(counter,counter2):= s_box_substitution_inverse(a,b);
		end loop;
	end loop;
	--Round 9
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
	--MixColumns
	for c in 3 downto 0 loop
		s := i(0,c) mod 16;
		t := i(0,c) / 16;
		u := i(1,c) mod 16;
		v := i(1,c) / 16;
		w := i(2,c) mod 16;
		x := i(2,c) / 16;
		y := i(3,c) mod 16;
		z := i(3,c) / 16;
		i(0,c) := to_integer(((to_unsigned(mul14(t,s),8)) xor (to_unsigned(mul11(v,u),8)) xor (to_unsigned(mul13(x,w),8)) xor (to_unsigned(mul9(z,y),8))));
		i(1,c) := to_integer(((to_unsigned(mul9(t,s),8)) xor (to_unsigned(mul14(v,u),8)) xor (to_unsigned(mul11(x,w),8)) xor (to_unsigned(mul13(z,y),8))));
		i(2,c) := to_integer(((to_unsigned(mul13(t,s),8)) xor (to_unsigned(mul9(v,u),8)) xor (to_unsigned(mul14(x,w),8)) xor (to_unsigned(mul11(z,y),8))));
		i(3,c) := to_integer(((to_unsigned(mul11(t,s),8)) xor (to_unsigned(mul13(v,u),8)) xor (to_unsigned(mul9(x,w),8)) xor (to_unsigned(mul14(z,y),8))));
	end loop;
	--ShiftRows
	row :=i(1,3);
	i(1,3):=i(1,2);
	i(1,2):=i(1,1);
	i(1,1):=i(1,0);
	i(1,0):=row;
	for counter in 2 downto 1 loop
	row :=i(2,3);
	i(2,3):=i(2,2);
	i(2,2):=i(2,1);
	i(2,1):=i(2,0);
	i(2,0):=row;
	end loop;
	for counter in 3 downto 1 loop
	row :=i(3,3);
	i(3,3):=i(3,2);
	i(3,2):=i(3,1);
	i(3,1):=i(3,0);
	i(3,0):=row;
	end loop;
	--SubBytes
	for counter in 3 downto 0 loop
		for counter2 in 3 downto 0 loop
			a := i(counter,counter2) / 16;
			b := i(counter,counter2) mod 16;
			i(counter,counter2):= s_box_substitution_inverse(a,b);
		end loop;
	end loop;
	--Round 10
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
	--MixColumns
	for c in 3 downto 0 loop
		s := i(0,c) mod 16;
		t := i(0,c) / 16;
		u := i(1,c) mod 16;
		v := i(1,c) / 16;
		w := i(2,c) mod 16;
		x := i(2,c) / 16;
		y := i(3,c) mod 16;
		z := i(3,c) / 16;
		i(0,c) := to_integer(((to_unsigned(mul14(t,s),8)) xor (to_unsigned(mul11(v,u),8)) xor (to_unsigned(mul13(x,w),8)) xor (to_unsigned(mul9(z,y),8))));
		i(1,c) := to_integer(((to_unsigned(mul9(t,s),8)) xor (to_unsigned(mul14(v,u),8)) xor (to_unsigned(mul11(x,w),8)) xor (to_unsigned(mul13(z,y),8))));
		i(2,c) := to_integer(((to_unsigned(mul13(t,s),8)) xor (to_unsigned(mul9(v,u),8)) xor (to_unsigned(mul14(x,w),8)) xor (to_unsigned(mul11(z,y),8))));
		i(3,c) := to_integer(((to_unsigned(mul11(t,s),8)) xor (to_unsigned(mul13(v,u),8)) xor (to_unsigned(mul9(x,w),8)) xor (to_unsigned(mul14(z,y),8))));
	end loop;
	--ShiftRows
	row :=i(1,3);
	i(1,3):=i(1,2);
	i(1,2):=i(1,1);
	i(1,1):=i(1,0);
	i(1,0):=row;
	for counter in 2 downto 1 loop
	row :=i(2,3);
	i(2,3):=i(2,2);
	i(2,2):=i(2,1);
	i(2,1):=i(2,0);
	i(2,0):=row;
	end loop;
	for counter in 3 downto 1 loop
	row :=i(3,3);
	i(3,3):=i(3,2);
	i(3,2):=i(3,1);
	i(3,1):=i(3,0);
	i(3,0):=row;
	end loop;
	--SubBytes
	for counter in 3 downto 0 loop
		for counter2 in 3 downto 0 loop
			a := i(counter,counter2) / 16;
			b := i(counter,counter2) mod 16;
			i(counter,counter2):= s_box_substitution_inverse(a,b);
		end loop;
	end loop;
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
output_signal1<=std_logic_vector(to_unsigned(i(3,3),8));
end process;
output1<=output_signal1;
end Behavioral;

