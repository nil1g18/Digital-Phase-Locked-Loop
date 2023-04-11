`include "config.sv"

module pll_d(
	output logic freq_synced,
	input freq_in,
	input Clock, nReset
	);
	
timeunit 1ns; timeprecision 10ps;

wire first_second, timeout, ready;
wire [`N_BIT-1:0] diff_1, diff_2, f_out;


pfd p0(
	.first_second, .timeout, .ready,
	.diff_1, .diff_2, .f_out,
	.f_1(freq_in), .f_2(freq_synced),
	.Clock, .nReset
);

freq_gen f0(.f_out(freq_synced),
	.first_second, .timeout, .ready,
	.diff_1, .diff_2, .f_in(f_out),
	.Clock, .nReset
	);

endmodule