`timescale 1ns/1ps

module test_MVMPU(	);

	reg clk;
	reg rst_n;
	reg start;
	wire ready;
	reg [15:0] matrix_n;
	reg [15:0] matrix_m;
	reg [`VAW-1:0] addr_rdsv;
	reg [`VAW-1:0] addr_wrsv;
	reg [`MAW-1:0] addr_rdsm;
	wire [`MAW-1:0] addr_rdm;
	wire [`VAW-1:0] addr_wrv;
	wire [`VAW-1:0] addr_rdv;
	reg din_valid;
	wire dout_valid;
	wire rd_en;
	wire [`INTWIDTH-1:0] sdout;
	reg [`MVPE_N*`INTWIDTH-1:0] dm;
	reg [`INTWIDTH-1:0] dv;
	wire [`MVPE_N*`INTWIDTH-1:0] dout;




initial begin
	#10 rst_n = 0;
	#10 rst_n = 1;
end

always begin
	#10 clk = !clk;
end


MVMPU u0(
	.clk(clk),
	.rst_n(rst_n),
	.start(start),
	.ready(ready),
	.matrix_n(matrix_n),
	.matrix_m(matrix_m),
	.addr_rdsv(addr_rdsv),
	.addr_wrsv(addr_wrsv),
	.addr_rdsm(addr_rdsm),
	.addr_rdm(addr_rdm),
	.addr_wrv(addr_wrv),
	.addr_rdv(addr_rdv),
	.din_valid(din_valid),
	.dout_valid(dout_valid),
	.rd_en(rd_en),
	.sdout(sdout),
	.dm(dm),
	.dv(dv),
	.dout(dout),
);

endmodule 

