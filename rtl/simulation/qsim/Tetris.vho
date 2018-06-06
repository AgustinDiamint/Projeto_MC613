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

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 17.1.0 Build 590 10/25/2017 SJ Lite Edition"

-- DATE "06/06/2018 15:07:55"

-- 
-- Device: Altera 5CSEMA5F31C6 Package FBGA896
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY ALTERA;
LIBRARY ALTERA_LNSIM;
LIBRARY CYCLONEV;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE ALTERA_LNSIM.ALTERA_LNSIM_COMPONENTS.ALL;
USE CYCLONEV.CYCLONEV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	create_piece IS
    PORT (
	clock : IN std_logic;
	sync_reset : IN std_logic;
	en : IN std_logic;
	piece : OUT std_logic_vector(2 DOWNTO 0)
	);
END create_piece;

ARCHITECTURE structure OF create_piece IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_clock : std_logic;
SIGNAL ww_sync_reset : std_logic;
SIGNAL ww_en : std_logic;
SIGNAL ww_piece : std_logic_vector(2 DOWNTO 0);
SIGNAL \piece[0]~output_o\ : std_logic;
SIGNAL \piece[1]~output_o\ : std_logic;
SIGNAL \piece[2]~output_o\ : std_logic;
SIGNAL \clock~input_o\ : std_logic;
SIGNAL \sync_reset~input_o\ : std_logic;
SIGNAL \r_lfsr~3_combout\ : std_logic;
SIGNAL \en~input_o\ : std_logic;
SIGNAL \r_lfsr[2]~2_combout\ : std_logic;
SIGNAL \r_lfsr~1_combout\ : std_logic;
SIGNAL \r_lfsr~0_combout\ : std_logic;
SIGNAL r_lfsr : std_logic_vector(3 DOWNTO 1);
SIGNAL ALT_INV_r_lfsr : std_logic_vector(3 DOWNTO 1);
SIGNAL \ALT_INV_en~input_o\ : std_logic;
SIGNAL \ALT_INV_sync_reset~input_o\ : std_logic;

BEGIN

ww_clock <= clock;
ww_sync_reset <= sync_reset;
ww_en <= en;
piece <= ww_piece;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
ALT_INV_r_lfsr(1) <= NOT r_lfsr(1);
\ALT_INV_en~input_o\ <= NOT \en~input_o\;
\ALT_INV_sync_reset~input_o\ <= NOT \sync_reset~input_o\;
ALT_INV_r_lfsr(3) <= NOT r_lfsr(3);
ALT_INV_r_lfsr(2) <= NOT r_lfsr(2);

\piece[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => r_lfsr(1),
	devoe => ww_devoe,
	o => \piece[0]~output_o\);

\piece[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => r_lfsr(2),
	devoe => ww_devoe,
	o => \piece[1]~output_o\);

\piece[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => r_lfsr(3),
	devoe => ww_devoe,
	o => \piece[2]~output_o\);

\clock~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clock,
	o => \clock~input_o\);

\sync_reset~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_sync_reset,
	o => \sync_reset~input_o\);

\r_lfsr~3\ : cyclonev_lcell_comb
-- Equation(s):
-- \r_lfsr~3_combout\ = (!\sync_reset~input_o\ & (!r_lfsr(1) $ (!r_lfsr(2))))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0110000001100000011000000110000001100000011000000110000001100000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => ALT_INV_r_lfsr(1),
	datab => ALT_INV_r_lfsr(2),
	datac => \ALT_INV_sync_reset~input_o\,
	combout => \r_lfsr~3_combout\);

\en~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_en,
	o => \en~input_o\);

\r_lfsr[2]~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \r_lfsr[2]~2_combout\ = (\en~input_o\) # (\sync_reset~input_o\)

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0111011101110111011101110111011101110111011101110111011101110111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_sync_reset~input_o\,
	datab => \ALT_INV_en~input_o\,
	combout => \r_lfsr[2]~2_combout\);

\r_lfsr[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~input_o\,
	d => \r_lfsr~3_combout\,
	ena => \r_lfsr[2]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => r_lfsr(3));

\r_lfsr~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \r_lfsr~1_combout\ = (r_lfsr(3) & !\sync_reset~input_o\)

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0100010001000100010001000100010001000100010001000100010001000100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => ALT_INV_r_lfsr(3),
	datab => \ALT_INV_sync_reset~input_o\,
	combout => \r_lfsr~1_combout\);

\r_lfsr[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~input_o\,
	d => \r_lfsr~1_combout\,
	ena => \r_lfsr[2]~2_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => r_lfsr(2));

\r_lfsr~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \r_lfsr~0_combout\ = ((!\en~input_o\ & (r_lfsr(1))) # (\en~input_o\ & ((r_lfsr(2))))) # (\sync_reset~input_o\)

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101111100111111010111110011111101011111001111110101111100111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => ALT_INV_r_lfsr(1),
	datab => ALT_INV_r_lfsr(2),
	datac => \ALT_INV_sync_reset~input_o\,
	datad => \ALT_INV_en~input_o\,
	combout => \r_lfsr~0_combout\);

\r_lfsr[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~input_o\,
	d => \r_lfsr~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => r_lfsr(1));

ww_piece(0) <= \piece[0]~output_o\;

ww_piece(1) <= \piece[1]~output_o\;

ww_piece(2) <= \piece[2]~output_o\;
END structure;


