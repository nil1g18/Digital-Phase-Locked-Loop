`include "config.sv"

module pll_d_test;
	
timeunit 1ns; timeprecision 10ps;

logic freq_in;
logic Clock, nReset;

wire freq_synced;

pll_d pll0(
	.freq_synced,
	.freq_in,
	.Clock, .nReset
	);
	
initial
begin
freq_in = 0;
Clock = 0;
nReset = 0;

#50 nReset = 1;

end

initial
begin
#100
for(int i = 0; i < 100; i++) begin
	#100 freq_in = ~freq_in;
	end
#100
for(int i = 0; i < 100; i++) begin
	#235 freq_in = ~freq_in;
	end
	
#100
for(int i = 0; i < 100; i++) begin
	#33 freq_in = ~freq_in;
	end	
	
#100
for(int i = 0; i < 100; i++) begin
	#1234 freq_in = ~freq_in;
	end
	
	
	
#1000 $stop;	
end


always
#0.5 Clock = ~Clock;

endmodule