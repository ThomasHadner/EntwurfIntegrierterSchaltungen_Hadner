//
// Simple testbench for the Counter
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

`include "counter.v"

module counter_tb;

	parameter MAX_COUNTER_VALUE = 160;
	
	// inputs
	reg reset_i = 1'b1;		// reset
	reg enable_i = 1'b0;	// enable signal
	reg clock_i = 1'b0;		// clock
	
	// outputs
	wire finished_o;
	wire [ $clog2(MAX_COUNTER_VALUE + 1) - 1 : 0 ] counter_val_o;
	
	// DUT
	counter
		#(
			MAX_COUNTER_VALUE
		)
		counter
		(
			.reset_i(reset_i),
			.enable_i(enable_i),
			.clock_i(clock_i),
			.finished_o(finished_o),
			.counter_val_o(counter_val_o)
		);
		
	// generate clock
	/* verilator lint_off STMTDLY */
	always #5 clock_i = ~clock_i;
	/* verilator lint_on STMTDLY */
	
	initial begin
		$dumpfile("counter_tb.vcd");
		$dumpvars;
		
		/* verilator lint_off STMTDLY */
		#20 reset_i = 1'b0;		// reassert reset
		#20 enable_i = 1'b1;	// siwtch on enable
		
		#50 enable_i = 1'b0;	// switch off enable
		#20 enable_i = 1'b1;	// switch on enable
		
		#180 enable_i = 1'b0;	// switch off enable
		
		#50 $finish;			// finish
		/* verilator lint_on STMTDLY */
	end

endmodule	// counter_tb











