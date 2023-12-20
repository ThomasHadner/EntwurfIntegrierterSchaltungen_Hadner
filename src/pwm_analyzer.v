/*
	Counter from 0 to MAX_VALUE
*/

`default_nettype none
`ifndef __PWMANALYZER__
`define __PWMANALYZER__

`include "counter.v"

module pwm_analyzer
	#( 
		parameter MAX_COUNTER_VALUE = 2000,		// max value of counter
		parameter HIGH_COUNTER_VALUE = 1750,	// above this value output is HIGH
		parameter LOW_COUNTER_VALUE = 1250		// below this value output is LOW
	)
	(
		input wire reset_i,			// reset
		input wire enable_i,		// enable signal
		input wire clock_i,			// clock
				
		output wire output_pin_o	// output of the PWM analyzer, HIGH when t_on > HIGH_COUNTER_VALUE, LOW when t_on < LOW_COUNTER_VALUE
	);
	
	wire [ $clog2(MAX_COUNTER_VALUE + 1) - 1 : 0 ] counter_val;	// register to store the counter value
	wire counter_finished;										// register to store the finished flag
	reg [ 0 : 0 ] output_pin;									// register for the output_pin
	
	assign output_pin_o = output_pin;
	
	// counter for info about t_on
	counter
		#(
			MAX_COUNTER_VALUE
		)
		counter
		(
			.reset_i(reset_i),
			.enable_i(enable_i),
			.clock_i(clock_i),
			.finished_o(counter_finished),
			.counter_val_o(counter_val)
		);
	
	always @ (posedge reset_i) begin
	
		output_pin <= 1'b0;
	
	end
	
	// check if counter value leads to output change
	always @ (posedge counter_finished) begin
	
		if (counter_val > HIGH_COUNTER_VALUE) begin
			
			output_pin <= 1'b1;
			
		end else begin
		
			if (counter_val < LOW_COUNTER_VALUE) begin
			
				output_pin <= 1'b0;
			
			end
			
		end
	
	end
	
	
endmodule	// pwm_analyzer

`endif
`default_nettype wire










