onerror {exit -code 1}
vlib work
vlog -work work lab4_part2.vo
vlog -work work Waveform19.vwf.vt
vsim -novopt -c -t 1ps -L cyclonev_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver work.part2_vlg_vec_tst -voptargs="+acc"
vcd file -direction lab4_part2.msim.vcd
vcd add -internal part2_vlg_vec_tst/*
vcd add -internal part2_vlg_vec_tst/i1/*
run -all
quit -f
