/*
	Simple testbench for the PWM Analyzer
*/

// Copyright 2024 Thomas Hadner
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

`timescale 1us / 100ns

`//include "tt_um_entwurf_integrierter_schaltungen_hadner.v"

module tb;

	parameter MAX_COUNTER_VALUE = 2000;		// max value of counter
	parameter HIGH_COUNTER_VALUE = 1900;	// above this value output is HIGH
	parameter LOW_COUNTER_VALUE = 1100;		// below this value output is LOW
	
    // wire up the inputs and outputs
    reg  clk = 1'b1;
    reg  rst_n = 1'b0;
    reg  ena = 1'b1;
    reg  [7:0] ui_in;
    reg  [7:0] uio_in;

	wire [7:0] uo_out;
    wire [6:0] segments = uo_out[6:0];    
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    tt_um_entwurf_integrierter_schaltungen_hadner
    	#(
    		MAX_COUNTER_VALUE,
    		HIGH_COUNTER_VALUE,
    		LOW_COUNTER_VALUE
    	)
    	tt_um_entwurf_integrierter_schaltungen_hadner_1
    	( 
			// include power ports for the Gate Level test
			`ifdef GL_TEST
				.VPWR( 1'b1),
				.VGND( 1'b0),
			`endif
			.ui_in      (ui_in),    // Dedicated inputs
			.uo_out     (uo_out),   // Dedicated outputs
			.uio_in     (uio_in),   // IOs: Input path
			.uio_out    (uio_out),  // IOs: Output path
			.uio_oe     (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
			.ena        (ena),      // enable - goes high when design is selected
			.clk        (clk),      // clock
			.rst_n      (rst_n)     // not reset
		);
		
	// generate clock
	/* verilator lint_off STMTDLY */
	always #0.5 clk = ~clk;
	/* verilator lint_on STMTDLY */
	
	initial begin
		$dumpfile("tb.vcd");
		$dumpvars;
		
		/* verilator lint_off STMTDLY */
		#10 ui_in[7:0] = 8'b00000000;	// reset all inputs
		
		#200 rst_n = 1'b1;			// reassert reset
		#200 ui_in[7:7] = 1'b1;		// switch on enable
		
		#2000 ui_in[7:7] = 1'b0;	// switch off enable
		#18000 ui_in[7:5] = 3'b111;	// switch on enable
		
		#2000 ui_in[7:5] = 3'b000;	// switch off enable
		#18000 ui_in[7:0] = 8'b11111111;	// switch on enable
		
		#2000 ui_in[7:0] = 8'b00000000;		// switch off enable
		#18000 ui_in[5:3] = 3'b111;	// switch on enable
		
		#2000 ui_in[5:3] = 3'b000;	// switch off enable
		
		#2000 $finish;			// finish
		/* verilator lint_on STMTDLY */
	end

endmodule	// tt_um_entwurf_integrierter_schaltungen_hadner
