`include "config.v"

//Matrix-Vector Mutiplication Process Unit (MVMPU) using Qint format
//input vector X [x1,x2,x3,...,xn]^T  cycle by cycle, which will use N cycles to finish operation

//input matrix W, to calculate W*X, need to input W col by col, each cycle inputs
//W
// c1  c2  ... cn				c:cycles
//[w11 w21 ... wn1]			
//[w12 w22 ... wn2]
//[w13 w23 ... wn3]
//...
//[w1m w2m ... wnm]

//c1: w11*x1 w12*x1 ... w1i*x1    i:number of arithmetic unit
//c2: w21*x2 w22*x2 ... w2i*x2
//cj: wj1*xj wj2*xj ... wji*xj

module MVMPU(
					clk, rst_n,
					matrix_m, matrix_n,
					start, ready,
					addr_rdsm,addr_rdsv,addr_wrsv,
					addr_rdm, addr_rdv,addr_wrv,
					rd_en,
					din_valid,dout_valid,
					
					sdout, dv,dm,dout
);

	input clk,rst_n;
input start;
	output wire ready;
input [15:0]matrix_n,matrix_m;
input [`VAW-1:0] addr_rdsv,addr_wrsv;
input [`MAW-1:0] addr_rdsm;

	output [`MAW-1:0] addr_rdm;
	output [`VAW-1:0] addr_wrv,addr_rdv;

input din_valid;
output dout_valid,rd_en;

output [`INTWIDTH-1:0] sdout;

input [`MVPE_N*`INTWIDTH-1:0] dm;		//input matrix data
input [`INTWIDTH-1:0] dv;					//input vector data
output [`MVPE_N*`INTWIDTH-1:0] dout;		//output data

//inner connect
wire pa_clr;
wire[7:0] sel;
assign sdout = dout >> (sel*`INTWIDTH);

MVMPU_CONTROLLER u0(.clk(clk),.rst_n(rst_n),
								  .start(start),.ready(ready),
								  .addr_rdsm(addr_rdsm),.addr_rdsv(addr_rdsv),.addr_wrsv(addr_wrsv),
								  .din_valid(din_valid),
								  .dout_valid(dout_valid),.pa_clr(pa_clr),
								  .matrix_m(matrix_m),.matrix_n(matrix_n),
								  .addr_rdv(addr_rdv),.addr_rdm(addr_rdm),
								  .rd_en(rd_en),
								  .sel(sel),.addr_wrv(addr_wrv));
								
MVMPU_PA u1(	.clk(clk),
					.rst_n(pa_clr),
					.din_valid(din_valid&rd_en),
					.din_v(dv),
					.din_m(dm),
					.dout(dout));

endmodule
