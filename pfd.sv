`include "config.sv"

module pfd (
	output logic first_second, timeout, ready,
	output logic [`N_BIT-1:0] diff_1, diff_2, f_out,
	input f_1, f_2,
	input Clock, nReset
);

timeunit 1ns; timeprecision 10ps;

logic [`N_BIT-1:0] counter_1, counter_2, f_count;

logic [1:0] state, state2;

logic [`N_BIT:0] timeout_counter;

always_ff @(posedge Clock, negedge nReset)
	if(~nReset)
	begin
		first_second <= 0;
		counter_1 <= 0;
		counter_2 <= 0;
		f_out <= 0;
		f_count <= 0;
		ready <= 0;
		diff_1 <= 0;
		diff_2 <= 0;
	end
	else
	begin
		case(state2)
		0: if(f_1)
			begin
			f_count <= 0;
			state2 <= 1;
			end
		
		1: if(f_1 == 0) begin
			f_out <= f_count;
			state2 <= 0;
			end
			else
			if(f_count < 2**`N_BIT-2)
				f_count <= f_count + 1;
		
		default: state2 <= 0;
		endcase
	
		case(state)
		//Wait for signal inputs
		0: begin
			if(f_1 ^ f_2)
				begin
				if(f_1)
					first_second <= 0;
				else
					first_second <= 1;
				
				ready <= 0;
				state <= 1;
				counter_1 <= 0;
				counter_2 <= 0;
				timeout_counter <= 0;
				end
			end
		
		//Signal difference measure
		1: begin
			if(f_1 & ~f_2)
				if(counter_1 < 2**`N_BIT-2)
					counter_1 <= counter_1 + 1;
			
			if(f_2 & ~f_1)
				if(counter_2 < 2**`N_BIT-2)
					counter_2 <= counter_2 + 1;
					
			if(f_1 == 0 & f_2 == 0)
				begin
				diff_1 <= counter_1;
				diff_2 <= counter_2;
				ready <= 1;
				state <= 0;
				end
				
			if(timeout_counter >= (2**`N_BIT-2))
				state <= 2;
			end
		
		//Timeout
		2: begin
			if(f_1 == 0 & f_2 == 0)
				begin
				diff_1 <= counter_1;
				diff_2 <= counter_2;
				ready <= 0;
				state <= 0;
				end
			end
		
		default: state <= 0;
		endcase
	end
	
assign timeout = (state == 2);
	
endmodule