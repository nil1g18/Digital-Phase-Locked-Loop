`include "config.sv"

module freq_gen(
	output logic f_out,
	input first_second, timeout, ready,
	input [`N_BIT-1:0] diff_1, diff_2, f_in,
	input Clock, nReset
	);

timeunit 1ns; timeprecision 10ps;

logic [1:0] state;

logic skip;

logic [`N_BIT:0] counter, difference;

always_ff @(posedge Clock, negedge nReset)
	if(~nReset)
	begin
		counter <= 0;
		difference <= 0;
		skip <= 0;
	end
	else
	begin
		if(timeout) begin
			difference <= 0;
			counter <= 0;
		end
				
		if(ready)
			skip <= !skip;
				
		if(ready & skip) begin
			if(difference >= 0)
				difference <= difference + diff_2 - diff_1;
			end
	
		case(state)
		//HIGH
		0: begin
				if(counter >= f_in)
					begin
					counter <= 0;
					state <= 1;
					end
				else
					counter <= counter + 1;
			end
		
		//LOW
		1: begin
			if(first_second)
				if(counter >= f_in + difference)
					begin
					counter <= 0;
					state <= 0;
					end
				else
					counter <= counter + 1;
			else
				if(f_in + difference >= 2)
					if(counter >= f_in - difference)
					begin
						counter <= 0;
						state <= 0;
						end
					else
						counter <= counter + 1;
				else
				if(counter >= f_in)
					begin
						counter <= 0;
						state <= 0;
						end
					else
						counter <= counter + 1;
			end
		
		default: state <= 0;
		endcase
	end
	
always_comb
begin
f_out = (state == 0);
end

endmodule
