//
// Simple UART Transmitter
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

`ifndef __UART_TRANSMITTER__
`define __UART_TRANSMITTER__

module uart_transmitter 
	#( 
		parameter INPUT_FEATURES = 8		// number of pwm channels
	)
	(
		input wire clock_i,
		input wire reset_i, 
		input wire [ $clog2(INPUT_FEATURES + 1) - 1 : 0 ] counter_i,
		
		output reg uart_transmit_o
	);

	reg [ $clog2(INPUT_FEATURES + 1) - 1 : 0 ] old_counter;
	reg [ $clog2(INPUT_FEATURES + 1) - 1 : 0 ] cur_counter;

	reg[2:0] state;
	reg[7:0] shift_reg;
	reg[2:0] bit_counter;
	
    always @(negedge clock_i) begin
		if (reset_i) begin
			state <= 3'b001;
			bit_counter <= 3'b000;
			old_counter <= counter_i;
			uart_transmit_o <= 1'b1;			// in Idle UART is HIGH

		end else begin
			case(state)
				3'b001: begin	// Checking for counter change
					cur_counter <= counter_i;
					uart_transmit_o <= 1'b1;	// in Idle UART is HIGH
					
					// if current and old counter are different, send message per UART
					if (counter_i != old_counter) begin
						state <= 3'b010;	// change state to Start Bit
					end
				
				end
				
				3'b010: begin	// Start Bit
					old_counter <= cur_counter;
					shift_reg <= { { ( 8 - $clog2(INPUT_FEATURES + 1)) {1'b0} } , cur_counter };
					uart_transmit_o <= 1'b0;
					state <= 3'b011;		// change state to checking for counter change
					bit_counter <= 3'b000;
				
				end
				
				3'b011: begin	// Data Bits
					uart_transmit_o <= shift_reg[bit_counter];
					bit_counter <= bit_counter + 3'b001;
					
					if (bit_counter == 3'b111) begin
						state <= 3'b100;	
					end			
				end
				
				3'b100: begin	// Stop Bit
					uart_transmit_o <= 1'b1;
					state <= 3'b001;		// change state to checking for counter change
				end
				
				default: state <= 3'b001;
				
			endcase
       	end 
    end

endmodule
`endif

