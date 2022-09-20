--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:40:56 12/12/2019
-- Design Name:   
-- Module Name:   C:/Users/TOSHIBA/Desktop/Final Code/Decryption/decryption/test2222.vhd
-- Project Name:  decryption
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: decrypt
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test2222 IS
END test2222;
 
ARCHITECTURE behavior OF test2222 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT decrypt
    PORT(
         output1 : OUT  std_logic_vector(7 downto 0);
         output2 : OUT  std_logic_vector(7 downto 0);
         output3 : OUT  std_logic_vector(7 downto 0);
         output4 : OUT  std_logic_vector(7 downto 0);
         output5 : OUT  std_logic_vector(7 downto 0);
         output6 : OUT  std_logic_vector(7 downto 0);
         output7 : OUT  std_logic_vector(7 downto 0);
         output8 : OUT  std_logic_vector(7 downto 0);
         output9 : OUT  std_logic_vector(7 downto 0);
         output10 : OUT  std_logic_vector(7 downto 0);
         output11 : OUT  std_logic_vector(7 downto 0);
         output12 : OUT  std_logic_vector(7 downto 0);
         output13 : OUT  std_logic_vector(7 downto 0);
         output14 : OUT  std_logic_vector(7 downto 0);
         output15 : OUT  std_logic_vector(7 downto 0);
         output16 : OUT  std_logic_vector(7 downto 0);
         switch : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal switch : std_logic := '0';

 	--Outputs
   signal output1 : std_logic_vector(7 downto 0);
   signal output2 : std_logic_vector(7 downto 0);
   signal output3 : std_logic_vector(7 downto 0);
   signal output4 : std_logic_vector(7 downto 0);
   signal output5 : std_logic_vector(7 downto 0);
   signal output6 : std_logic_vector(7 downto 0);
   signal output7 : std_logic_vector(7 downto 0);
   signal output8 : std_logic_vector(7 downto 0);
   signal output9 : std_logic_vector(7 downto 0);
   signal output10 : std_logic_vector(7 downto 0);
   signal output11 : std_logic_vector(7 downto 0);
   signal output12 : std_logic_vector(7 downto 0);
   signal output13 : std_logic_vector(7 downto 0);
   signal output14 : std_logic_vector(7 downto 0);
   signal output15 : std_logic_vector(7 downto 0);
   signal output16 : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: decrypt PORT MAP (
          output1 => output1,
          output2 => output2,
          output3 => output3,
          output4 => output4,
          output5 => output5,
          output6 => output6,
          output7 => output7,
          output8 => output8,
          output9 => output9,
          output10 => output10,
          output11 => output11,
          output12 => output12,
          output13 => output13,
          output14 => output14,
          output15 => output15,
          output16 => output16,
          switch => switch
        );


 

   -- Stimulus process
   stim_proc: process
   begin		
 
   end process;

END;
