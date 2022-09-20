--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:54:13 12/10/2019
-- Design Name:   
-- Module Name:   C:/Users/TOSHIBA/Desktop/Decryption/decryption/key_test.vhd
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
 
ENTITY key_test IS
END key_test;
 
ARCHITECTURE behavior OF key_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT decrypt
   Port(output1: out std_logic_vector(7 downto 0);
	  switch: in std_logic);
    END COMPONENT;
    --Inoputs
	 signal switch : std_logic;

 	--Outputs
   signal output1 : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: decrypt PORT MAP (
          output1 => output1,
			 switch => switch
        );


 

   -- Stimulus process
   stim_proc: process
   begin		
 switch <= '0';
 wait for 100 ns;
 switch <= '1';
 wait for 100 ns;
   end process;

END;
