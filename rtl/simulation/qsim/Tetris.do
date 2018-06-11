onerror {exit -code 1}
vlib work
vcom -work work Tetris.vho
vcom -work work output_files/Waveform1_crtpc.vwf.vht
vsim -novopt -c -t 1ps -L cyclonev -L altera -L altera_mf -L 220model -L sgate -L altera_lnsim work.create_piece_vhd_vec_tst
vcd file -direction Tetris.msim.vcd
vcd add -internal create_piece_vhd_vec_tst/*
vcd add -internal create_piece_vhd_vec_tst/i1/*
proc simTimestamp {} {
    echo "Simulation time: $::now ps"
    if { [string equal running [runStatus]] } {
        after 2500 simTimestamp
    }
}
after 2500 simTimestamp
run -all
quit -f
