//
// Simple testbench for the PWM Analyzer
//
//
// Copyright 2023 Thomas Hadner
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE−2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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









