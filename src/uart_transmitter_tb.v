//
// Simple testbench for the UART Transmitter
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

`timescale 1us / 1us

`include "uart_transmitter.v"

module uart_transmitter_tb;

	parameter INPUT_FEATURES = 8;
	
	reg reset_i = 1'b1;		// reset
	reg clock_i = 1'b0;		// clock
	reg [ $clog2(INPUT_FEATURES + 1) - 1 : 0 ] counter = 4'b0000;	// counter values which should be send via UART
	
	wire uart_transmit;
	
	// DUT
	uart_transmitter
		#(
			INPUT_FEATURES
		)
		uart_transmitter_1
		(
			.reset_i(reset_i),
			.clock_i(clock_i),
			.counter_i(counter),
			.uart_transmit_o(uart_transmit)
		);
		
	// generate clock
	/* verilator lint_off STMTDLY */
	always #5 clock_i = ~clock_i;
	/* verilator lint_on STMTDLY */
	
	initial begin
		$dumpfile("uart_transmitter_tb.vcd");
		$dumpvars;
		
		/* verilator lint_off STMTDLY */
		#15 reset_i = 1'b0;	// reassert reset

		#1000 counter <= 4'b1010;
		
		#10000 counter <= 4'b1110;
		
		#5000 $finish;		// finish
		/* verilator lint_on STMTDLY */
	end

endmodule	// counter_tb
