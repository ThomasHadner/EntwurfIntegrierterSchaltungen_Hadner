iic-vlint.sh counter_tb.v
iverilog -g2005 -o COUNTER counter_tb.v
vvp COUNTER
gtkwave counter_tb.vcd
