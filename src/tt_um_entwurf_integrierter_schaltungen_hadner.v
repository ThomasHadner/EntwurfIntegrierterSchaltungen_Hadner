//
// KV Entwurf Integrierter Schaltungen - Design Hadner
// Demodulator for RC Receiver with different Outputs
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

`default_nettype none
`include "pwm_analyzer.v"
`include "ones_counter.v"
`include "seg7.v"

`ifndef __KEIS_HADNER__
`define __KEIS_HADNER__

module tt_um_entwurf_integrierter_schaltungen_hadner 
	#(
		parameter MAX_COUNTER_VALUE = 2000,		// max value of counter
		parameter HIGH_COUNTER_VALUE = 1800,	// above this value output is HIGH
		parameter LOW_COUNTER_VALUE = 1200,		// below this value output is LOW
		
		parameter INPUT_FEATURES = 8			// number of input features for the ones_counter
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
    wire [ $clog2(INPUT_FEATURES + 1) - 1 : 0 ] ones_counter_o;
    wire [6:0] led_out;
    wire uart_transmit;

    // use bidirectionals as outputs
    assign uio_oe = 8'b11111111;
    
    assign uo_out[6:0] = led_out;		// for the 7 seg
    assign uo_out[7] = uart_transmit;	// for UART transmission

    // external clock is configured to 1MHz
    pwm_analyzer
		#(	
			MAX_COUNTER_VALUE,
			HIGH_COUNTER_VALUE,
			LOW_COUNTER_VALUE
		)
		pwm_analyzer_0
		(
			.reset_i(reset),
			.enable_i(ui_in[0]),
			.clock_i(clk),
			.output_pin_o(uio_out[0])
		);
		
	pwm_analyzer
		#(	
			MAX_COUNTER_VALUE,
			HIGH_COUNTER_VALUE,
			LOW_COUNTER_VALUE
		)
		pwm_analyzer_1
		(
			.reset_i(reset),
			.enable_i(ui_in[1]),
			.clock_i(clk),
			.output_pin_o(uio_out[1])
		);
		
	pwm_analyzer
		#(	
			MAX_COUNTER_VALUE,
			HIGH_COUNTER_VALUE,
			LOW_COUNTER_VALUE
		)
		pwm_analyzer_2
		(
			.reset_i(reset),
			.enable_i(ui_in[2]),
			.clock_i(clk),
			.output_pin_o(uio_out[2])
		);
		
	pwm_analyzer
		#(	
			MAX_COUNTER_VALUE,
			HIGH_COUNTER_VALUE,
			LOW_COUNTER_VALUE
		)
		pwm_analyzer_3
		(
			.reset_i(reset),
			.enable_i(ui_in[3]),
			.clock_i(clk),
			.output_pin_o(uio_out[3])
		);
		
	pwm_analyzer
		#(	
			MAX_COUNTER_VALUE,
			HIGH_COUNTER_VALUE,
			LOW_COUNTER_VALUE
		)
		pwm_analyzer_4
		(
			.reset_i(reset),
			.enable_i(ui_in[4]),
			.clock_i(clk),
			.output_pin_o(uio_out[4])
		);
		
	pwm_analyzer
		#(	
			MAX_COUNTER_VALUE,
			HIGH_COUNTER_VALUE,
			LOW_COUNTER_VALUE
		)
		pwm_analyzer_5
		(
			.reset_i(reset),
			.enable_i(ui_in[5]),
			.clock_i(clk),
			.output_pin_o(uio_out[5])
		);
		
	pwm_analyzer
		#(	
			MAX_COUNTER_VALUE,
			HIGH_COUNTER_VALUE,
			LOW_COUNTER_VALUE
		)
		pwm_analyzer_6
		(
			.reset_i(reset),
			.enable_i(ui_in[6]),
			.clock_i(clk),
			.output_pin_o(uio_out[6])
		);
		
	pwm_analyzer
		#(	
			MAX_COUNTER_VALUE,
			HIGH_COUNTER_VALUE,
			LOW_COUNTER_VALUE
		)
		pwm_analyzer_7
		(
			.reset_i(reset),
			.enable_i(ui_in[7]),
			.clock_i(clk),
			.output_pin_o(uio_out[7])
		);
	
	// include the ones_counter
	ones_counter
		#(
			INPUT_FEATURES
		)
		ones_counter_1
		(
			.reset_i(reset),
			.clock_i(clk),
			.input_features_i(uio_out),			// outputs of the PWM_Analyzers
			.ones_o(ones_counter_o)
		);
	
	// 7 segment shows counter which shows how many outputs are HIGH
	seg7
		#(
		)
		seg7_1
		(
			.counter(ones_counter_o),
			.segments(led_out)
		);
		

endmodule	// tt_um_entwurf_integrierter_schaltungen_hadner

`endif
`default_nettype wire
