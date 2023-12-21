//
// KV Entwurf Integrierter Schaltungen - Design Hadner
// Demodulator for RC Receiver with different Outputs
//
//
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

`default_nettype none
`include "pwm_analyzer.v"

module tt_um_entwurf_integrierter_schaltungen_hadner 
	#(
		parameter MAX_COUNTER_VALUE = 2000,		// max value of counter
		parameter HIGH_COUNTER_VALUE = 1800,	// above this value output is HIGH
		parameter LOW_COUNTER_VALUE = 1200		// below this value output is LOW
	)
	(
		input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
		output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
		
		input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
		output wire [7:0] uio_out,  // IOs: Bidirectional Output path
		output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
		
		input  wire       ena,      // will go high when the design is enabled
		input  wire       clk,      // clock
		input  wire       rst_n     // reset_n - low to reset
	);

    wire reset = ! rst_n;
    wire [6:0] led_out;
    assign uo_out[6:0] = 7'b0000000;
    assign uo_out[7] = 1'b0;

    // use bidirectionals as outputs
    assign uio_oe = 8'b11111111;

    // put bottom 8 bits of second counter out on the bidirectional gpio
//    assign uio_out = second_counter[7:0];

    // external clock is configured to 1MHz
    
    pwm_analyzer
		#(	
			MAX_COUNTER_VALUE,
			HIGH_COUNTER_VALUE,
			LOW_COUNTER_VALUE
		)
		pwm_analyzer
		(
			.reset_i(reset),
			.enable_i(ui_in[7:7]),
			.clock_i(clk),
			.output_pin_o(uo_out[0:0])
		);
    

endmodule	// tt_um_entwurf_integrierter_schaltungen_hadner
`default_nettype wire
