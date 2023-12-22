//
// Simple Ones Counter
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
`ifndef __ONES_COUNTER__
`define __ONES_COUNTER__

module ones_counter
	#( 
		parameter INPUT_FEATURES = 8	// number of input wires which has to be checked for HIGH
	)
	(
		input wire reset_i,		// reset
		input wire clock_i,		// clock
		input wire [ INPUT_FEATURES - 1 : 0 ] input_features_i,		// input features which has to be checked for HIGH
		
		output wire [ $clog2(INPUT_FEATURES + 1) - 1 : 0 ] ones_o	// number of ones, with INPUT_FEATURES = 8, we need 4 bits
	);
	
	integer i;					// variable for the for loop
	
	reg [ $clog2(INPUT_FEATURES + 1) - 1 : 0 ] ones;
	
	assign ones_o = ones;
	
	always @ (negedge clock_i) begin

		// check for reset
		if ( reset_i == 1'b1 ) begin
		
			ones <= 0;
		
		end else begin
		
			// initialize count variable
			ones <= 0;
			
			// go through all input features
			for ( i = 0; i < INPUT_FEATURES; i = i + 1)   	
			
				if(input_features_i[i] == 1'b1)  begin  	// check if the bit is '1'
					ones <= ones + 1;    					// if its one, increment the count
				end
				
		end
		
	end
	
endmodule	// ones_counter

`endif
`default_nettype wire
