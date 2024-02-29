iic-vlint.sh uart_transmitter_tb.v
iverilog -g2005 -o UART_TRANSMITTER uart_transmitter_tb.v
vvp UART_TRANSMITTER
gtkwave uart_transmitter_tb.vcd
