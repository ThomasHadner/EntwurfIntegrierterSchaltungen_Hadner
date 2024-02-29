//
// Simple testbench for the Ones Counter
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

`include "ones_counter.v"

module ones_counter_tb;

	parameter INPUT_FEATURES = 8;
	
	reg reset_i = 1'b1;		// reset
	reg clock_i = 1'b0;		// clock
	reg [ INPUT_FEATURES - 1 : 0 ] input_features_i = 8'b00000000;	// input features which has to be checked for HIGH
	
	wire [ $clog2(INPUT_FEATURES + 1) - 1 : 0 ] ones_o;	// number of ones
	
	// DUT
	ones_counter
		#(
			INPUT_FEATURES
		)
		ones_counter_1
		(
			.reset_i(reset_i),
			.clock_i(clock_i),
			.input_features_i(input_features_i),
			.ones_o(ones_o)
		);
		
	// generate clock
	/* verilator lint_off STMTDLY */
	always #5 clock_i = ~clock_i;
	/* verilator lint_on STMTDLY */
	
	initial begin
		$dumpfile("ones_counter_tb.vcd");
		$dumpvars;
		
		/* verilator lint_off STMTDLY */
		#15 reset_i = 1'b0;	// reassert reset

		#15 input_features_i = 8'b00000000;	// 0
		
		#30 input_features_i = 8'b00000001;	// 1
		#30 input_features_i = 8'b00100000;	// 1
		
		#30 input_features_i = 8'b00001010;	// 2
		#30 input_features_i = 8'b10000100;	// 2

		#30 input_features_i = 8'b00001110;	// 3
		#30 input_features_i = 8'b00001101;	// 3
	
		#30 input_features_i = 8'b11001010;	// 4
		#30 input_features_i = 8'b00101101;	// 4

		#30 input_features_i = 8'b01011101;	// 5
		#30 input_features_i = 8'b11101100;	// 5
		
		#30 input_features_i = 8'b11101110;	// 6
		#30 input_features_i = 8'b00111111;	// 6
		
		#30 input_features_i = 8'b01111111;	// 7
		
		#30 input_features_i = 8'b11111111;	// 8
		
		#50 $finish;		// finish
		/* verilator lint_on STMTDLY */
	end

endmodule	// counter_tb
