`include "config.sv"

module pfd_test;

timeunit 1ns; timeprecision 10ps;

logic f_1, f_2;
logic Clock, nReset;
wire first_second, timeout, ready;
wire [`N_BIT-1:0] diff_1, diff_2, f_out;

pfd p0( .first_second, .timeout, .ready,
	.diff_1, .diff_2, .f_out,
	.f_1, .f_2,
	.Clock, .nReset);
	
initial
begin
f_1 = 0;
f_2 = 0;
Clock = 0;
nReset = 0;

#50 nReset = 1;

end

initial
begin
#100
for(int i = 0; i < 100; i ++) begin
	#100 f_1 = ~f_1;
	end
	
end

initial
begin
#120
for(int i = 0; i < 100; i ++) begin
	#100 f_2 = ~f_2;
	end
	
end

initial
#5000 $stop;

always
#0.5 Clock = ~Clock;

endmodule