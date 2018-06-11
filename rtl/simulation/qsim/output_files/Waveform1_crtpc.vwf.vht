-- Copyright (C) 2017  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "06/11/2018 17:06:38"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          create_piece
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY create_piece_vhd_vec_tst IS
END create_piece_vhd_vec_tst;
ARCHITECTURE create_piece_arch OF create_piece_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clock : STD_LOGIC;
SIGNAL en : STD_LOGIC;
SIGNAL piece : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL sync_reset : STD_LOGIC;
COMPONENT create_piece
	PORT (
	clock : IN STD_LOGIC;
	en : IN STD_LOGIC;
	piece : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
	sync_reset : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : create_piece
	PORT MAP (
-- list connections between master ports and signals
	clock => clock,
	en => en,
	piece => piece,
	sync_reset => sync_reset
	);

-- clock
t_prcs_clock: PROCESS
BEGIN
LOOP
	clock <= '0';
	WAIT FOR 10000 ps;
	clock <= '1';
	WAIT FOR 10000 ps;
	IF (NOW >= 1000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_clock;

-- en
t_prcs_en: PROCESS
BEGIN
	en <= '1';
WAIT;
END PROCESS t_prcs_en;

-- sync_reset
t_prcs_sync_reset: PROCESS
BEGIN
	sync_reset <= '1';
	WAIT FOR 120000 ps;
	sync_reset <= '0';
WAIT;
END PROCESS t_prcs_sync_reset;
END create_piece_arch;
