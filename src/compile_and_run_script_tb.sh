iic-vlint.sh tb.v
iverilog -g2005 -o EIS_HADNER tb.v
vvp EIS_HADNER
gtkwave tb.vcd
