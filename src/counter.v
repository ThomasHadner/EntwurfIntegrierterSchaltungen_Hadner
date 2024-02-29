//
// Counter from 0 to MAX_VALUE
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
`ifndef __COUNTER__
`define __COUNTER__

module counter
	#( 
		parameter MAX_COUNTER_VALUE = 2000	// max value of counter
	)
	(
		input wire reset_i,			// reset
		input wire enable_i,		// enable signal
		input wire clock_i,			// clock
				
		output wire finished_o,			// signal which shows finish of counting
		output wire [ $clog2(MAX_COUNTER_VALUE + 1) - 1 : 0 ] counter_val_o		// counter value
	);
	
	// start the module implementation
	reg [ $clog2(MAX_COUNTER_VALUE + 1) - 1 : 0 ] counter_val;	// register to store the counter value
	reg [ 0 : 0 ] finished;						// register to store the finished flag
	
	assign counter_val_o = counter_val;			// assign the counter value to the output
	assign finished_o = finished;				// assign the finished value to the output

	integer last_enable_state = 0;
	integer current_enable_state = 0;

	// gets active always when a positive edge of the clock signal occours
	always @ ( posedge clock_i ) begin
	
		last_enable_state = current_enable_state;	// save old enable state
		current_enable_state = { { 31 {1'b0} } , enable_i };			// assign enable
	
		// reset is active
		if ( reset_i == 1'b1) begin
			finished <= 1'b0;
			
			counter_val <= { $clog2(MAX_COUNTER_VALUE + 1) {1'b0} };	// reset counter value
			
			last_enable_state = 0;
			current_enable_state = 0;
			
		// reset is disabled
		end else begin		
		
			// increment the counter value by 1 if enable is active
			if ( enable_i == 1'b1 ) begin
				// had rising edge on enable
				if ( last_enable_state == 0) begin
					finished <= 1'b0;
					counter_val <= { $clog2(MAX_COUNTER_VALUE + 1) {1'b0} };	// reset counter value
				end else begin
				
					// increment counter if smaller MAX_COUNTER_VALUE, else finished
					if ( counter_val < MAX_COUNTER_VALUE ) begin
						counter_val <= counter_val + { { ($clog2(MAX_COUNTER_VALUE + 1) - 1) {1'b0} } , 1'b1 };
					end else begin 
						if ( counter_val == MAX_COUNTER_VALUE ) begin
							finished <= 1'b1;	// set finished to high
						end
					end
				end
				
			end else begin
				// had falling edge on enable
				if ( last_enable_state == 1 ) begin
					finished <= 1'b1;		// set finished to high			
				end
			end
		end
	end
	
endmodule	// counter

`endif
`default_nettype wire
