iic-vlint.sh pwm_analyzer_tb.v
iverilog -g2005 -o PWM_ANALYZER pwm_analyzer_tb.v
vvp PWM_ANALYZER
gtkwave pwm_analyzer_tb.vcd
