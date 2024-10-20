vlib work
vlog FIFO_inter.sv TOP_FIFO.sv FIFO.sv FIFO_tb.sv FIFO_monitor.sv pack_FIFO_transaction.sv pack_FIFO_coverage.sv pack_FIFO_scoreboard.sv shared_pkg.sv +cover -covercells
vsim -voptargs=+acc work.TOP_FIFO -cover
add wave *
coverage save TOP_FIFO.ucdb -onexit
add wave -position insertpoint  \
sim:/TOP_FIFO/FIFO_if/FIFO_WIDTH \
sim:/TOP_FIFO/FIFO_if/FIFO_DEPTH \
sim:/TOP_FIFO/FIFO_if/clk \
sim:/TOP_FIFO/FIFO_if/data_in \
sim:/TOP_FIFO/FIFO_if/rst_n \
sim:/TOP_FIFO/FIFO_if/wr_en \
sim:/TOP_FIFO/FIFO_if/rd_en \
sim:/TOP_FIFO/FIFO_if/data_out \
sim:/TOP_FIFO/FIFO_if/wr_ack \
sim:/TOP_FIFO/FIFO_if/overflow \
sim:/TOP_FIFO/FIFO_if/full \
sim:/TOP_FIFO/FIFO_if/empty \
sim:/TOP_FIFO/FIFO_if/almostfull \
sim:/TOP_FIFO/FIFO_if/almostempty \
sim:/TOP_FIFO/FIFO_if/underflow

run -all

quit -sim
vcover report TOP_FIFO.ucdb -details -all -output coverage.txt 

