--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:39:13 12/11/2019
-- Design Name:   
-- Module Name:   C:/Users/TOSHIBA/Desktop/Encryption/encryption/encrypt_test.vhd
-- Project Name:  encryption
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: encrypt
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
 
ENTITY encrypt_test IS
END encrypt_test;
 
ARCHITECTURE behavior OF encrypt_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT encrypt
    PORT(
         output : OUT  std_logic_vector(7 downto 0);
         switch : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal switch : std_logic;

 	--Outputs
   signal output : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: encrypt PORT MAP (
          output => output,
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
