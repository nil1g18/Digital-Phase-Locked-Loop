`include "config.sv"

module freq_gen_test;

timeunit 1ns; timeprecision 10ps;

wire f_out;
logic Clock, nReset;
logic first_second, timeout, ready;
logic [`N_BIT-1:0] diff_1, diff_2, f_in;

freq_gen f0(
	.f_out,
	.first_second, .timeout, .ready,
	.diff_1, .diff_2, .f_in,
	.Clock, .nReset
	);
	
initial
begin
first_second = 0;
timeout = 0;
ready = 0;
Clock = 0;
nReset = 0;

#50 nReset = 1;

#50 ready = !ready;
#50 ready = !ready;
#100
diff_1 = 650;
diff_2 = 400;
f_in = 30;
#50 ready = !ready;

#50 ready = !ready;


#500
diff_1 = 20;
diff_2 = 25;
f_in = 30;
#50 ready = !ready;
#50 ready = !ready;


#500
diff_1 = 0;
diff_2 = 1;
f_in = 100;
#50 ready = !ready;
#50 ready = !ready;

#500
diff_1 = 0;
diff_2 = 0;
f_in = 500;
#50 ready = !ready;
#50 ready = !ready;

#500
diff_1 = 0;
diff_2 = 0;
f_in = 4;
#50 ready = !ready;
#50 ready = !ready;


end


initial
#10000 $stop;

always
#0.5 Clock = ~Clock;

endmodule