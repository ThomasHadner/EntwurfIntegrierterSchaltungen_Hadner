iic-vlint.sh ones_counter_tb.v
iverilog -g2005 -o ONES_COUNTER ones_counter_tb.v
vvp ONES_COUNTER
gtkwave ones_counter_tb.vcd
