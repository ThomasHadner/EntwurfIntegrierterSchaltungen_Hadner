/*
	Simple testbench for the PWM Analyzer
*/

`timescale 1ns / 1ns

`include "pwm_analyzer.v"

module pwm_analyzer_tb;

	parameter MAX_COUNTER_VALUE = 2000;		// max value of counter
	parameter HIGH_COUNTER_VALUE = 12;		// above this value output is HIGH
	parameter LOW_COUNTER_VALUE = 11;		// below this value output is LOW
	
	// inputs
	reg reset_i = 1'b1;		// reset
	reg enable_i = 1'b0;	// enable signal
	reg clock_i = 1'b0;		// clock
	
	// outputs
	wire output_pin_o;
	
	pwm_analyzer
		#(	
			MAX_COUNTER_VALUE,
			HIGH_COUNTER_VALUE,
			LOW_COUNTER_VALUE
		)
		pwm_analyzer
		(
			.reset_i(reset_i),
			.enable_i(enable_i),
			.clock_i(clock_i),
			.output_pin_o(output_pin_o)
		);
		
	// generate clock
	/* verilator lint_off STMTDLY */
	always #500 clock_i = ~clock_i;
	/* verilator lint_on STMTDLY */
	
	initial begin
		$dumpfile("pwm_analyzer_tb.vcd");
		$dumpvars;
		
		/* verilator lint_off STMTDLY */
		#200 reset_i = 1'b0;	// reassert reset
		#200 enable_i = 1'b1;	// switch on enable
		
		#100 enable_i = 1'b0;	// switch off enable
		#190 enable_i = 1'b1;	// switch on enable
		
		#200 enable_i = 1'b0;	// switch off enable
		
		#50 $finish;			// finish
		/* verilator lint_on STMTDLY */
	end

endmodule	// counter_tb









