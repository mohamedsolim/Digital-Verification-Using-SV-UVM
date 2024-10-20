vlib work
vlog *v +cover
vsim -voptargs=+acc work.FIFO_top -classdebug -uvmcontrol=all -cover
add wave /FIFO_top/FIFOif/*
coverage save top.ucdb -onexit
run -all

quit -sim
vcover report top.ucdb -details -all -output coverage.txt
