`include "config.v"

//卷积图像存储处理模块
//串行写入，并行读取		`CORE_N个数据转`KSIZE个数据
module MMU_XRAM(
		clk, rst_n,wr_finish,
		X_wr,X_din, X_din_valid,
		X_rd,X_dout,X_dout_valid
);

parameter ITERA = `KSIZE/`CORE_N;

input clk,rst_n;
input [`VAW - 1:0] X_wr,X_rd;
input [`INTWIDTH * `CORE_N- 1 : 0] X_din;
output [`INTWIDTH * `KSIZE - 1 : 0] X_dout;
input wr_finish;

input X_din_valid;
output X_dout_valid;

assign X_dout_valid = 1'b1;

//串转并RAM
wire [ITERA-1:0] CSn = 	(X_wr[1:0] == 2'd0)?4'b1110:
						(X_wr[1:0] == 2'd1)?4'b1101:
						(X_wr[1:0] == 2'd2)?4'b1011:
						(X_wr[1:0] == 2'd3)?4'b0111:4'b1111;


genvar gv_i;
generate 
	for(gv_i = 0; gv_i < ITERA; gv_i = gv_i + 1'b1)
	begin:xram_gen
	BASE_RAM#(
			.DWIDTH(`CORE_N*`INTWIDTH),
			.AWIDTH(`VAW)
			)
			uxr(
			.clk(clk),
			.rst_n(rst_n),
			.CSn(CSn[gv_i]&X_din_valid),
			.addr_rd(X_rd),
			.addr_wr(X_wr/ITERA),
			.din(X_din),
			.dout(X_out[gv_i])
			);
	end
endgenerate

endmodule


