`include "config.v"

module test_MMU_XRAM(
	input wire clk,
	input wire rst_n,
	output reg [`VAW-1:0] X_wr,
	output reg [`VAW-1:0] X_rd,
	output reg [`INTWIDTH*`CORE_N-1:0] X_din,
	input wire [`INTWIDTH*`KSIZE-1:0] X_dout,
	output reg wr_finish,
	output reg X_din_valid,
	input wire X_dout_valid,
);



endmodule

