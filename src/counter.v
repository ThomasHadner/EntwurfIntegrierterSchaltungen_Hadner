/*
	Counter from 0 to MAX_VALUE
*/

`default_nettype none
`ifndef __COUNTER__
`define __COUNTER__

module counter
	#( 
		parameter MAX_COUNTER_VALUE = 2000	// max value of counter
	)
	(
		input wire reset_i,			// reset
		input wire enable_i,			// enable signal
		input wire clock_i,			// clock
				
		output wire finished_o,			// signal which shows finish of counting
		output wire [ $clog2(MAX_COUNTER_VALUE + 1) - 1 : 0 ] counter_val_o		// counter value
	);
	
	// start the module implementation
	reg [ $clog2(MAX_COUNTER_VALUE + 1) - 1 : 0 ] counter_val;	// register to store the counter value
	reg [ 0 : 0 ] finished;						// register to store the finished flag
	reg [ 0 : 0 ] falling_edge_on_enable;				// register to store if the enable edge falled down
	
	assign counter_val_o = counter_val;				// assign the counter value to the output
	assign finished_o = finished;					// assign the finished value to the output

	// gets active always when a positive edge of the clock signal occours
	always @ ( posedge clock_i ) begin
		// reset is active
		if ( reset_i == 1'b1) begin
			finished <= 1'b0;
			falling_edge_on_enable <= 1'b0;
			counter_val <= { $clog2(MAX_COUNTER_VALUE + 1) {1'b0} };
		// reset is disabled
		end else begin		
			// increment the counter value by 1 if enable is active
			if ( enable_i == 1'b1 ) begin
				if ( counter_val < MAX_COUNTER_VALUE ) begin
					counter_val <= counter_val + { { ($clog2(MAX_COUNTER_VALUE + 1) - 1) {1'b0} } , 1'b1 };
				end else begin 
					if ( counter_val == MAX_COUNTER_VALUE ) begin
						finished <= 1'b1;		// set finished to high
					end
				end
			end else begin
				if (falling_edge_on_enable == 1'b1) begin
					finished <= 1'b1;	// set finished to high			
				end
			end
		end
	end
	
	always @ (posedge reset_i) begin
		counter_val <= { $clog2(MAX_COUNTER_VALUE + 1) {1'b0} }; 	// reset the counter value
		finished <= 1'b0;
		falling_edge_on_enable <= 1'b0;		
	end
	
	// reset counter on new enable
	always @ (posedge enable_i) begin
		finished <= 1'b0;
		falling_edge_on_enable <= 1'b0;
		counter_val <= { $clog2(MAX_COUNTER_VALUE + 1) {1'b0} };
	end
	
	// store that enable had falling edge
	always @ (negedge enable_i) begin
		falling_edge_on_enable <= 1'b1;
	end		
	
endmodule	// counter

`endif
`default_nettype wire
