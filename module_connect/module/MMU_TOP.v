`include "config.v"

module MMU_TOP(
						clk,rst_n,
						cmd,start,ready,																		//控制模式选择接口

						//CALC_CORE接口:卷积和全连接
						X_dout, X_din,  X_rd, X_wr, X_din_valid, X_dout_valid,				//串写并读：core输入接口 X
						W_dout, W_din,  W_rd, W_wr, W_din_valid, W_dout_valid,				//串写并读：core输入接口 W
						Y_din,  Y_dout, Y_rd, Y_wr, Y_din_valid, Y_dout_valid,				//并行写串读：core输出接口 Y == ACTIVE和POOLING 接口
						B_din,  B_dout, B_rd, B_wr, B_din_valid, B_dout_valid,				//阈值存储器
						
						cfifo_cfg,  cfifo_cfg_len,  cfifo_dvalid, cfifo_load0,
						
						
						//外部接口
						
						//sdram				加速核私有
						
						//sram				加速核私有
						
						//flash				加速核私有
						
						//avalon-MM总线	总线从设备
						
);

input clk,rst_n;
input start;
output ready;

input [2:0] cmd;
//000:数据X从内部搬运到外部 
//001:数据W从内部搬运到外部
//010:
//011:
//100:
//101:
//110:
//111:

	output [`INTWIDTH*`KSIZE*`CORE_N-1:0] X_dout;

	input [`MAW-1:0] B_rd;
	input [`MAW-1:0] B_wr;
	input [`CORE_N*`INTWIDTH:0] B_din;
	output [`INTWIDTH*`CORE_N-1:0] B_dout;
	input B_din_valid;
	output B_dout_valid;

	//signal of module MMU_CFIFO, Please define the input and output by yourself
	input cfifo_cfg;
	input [`FIFO_WIDTH-1:0] cfifo_cfg_len;
	input cfifo_dvalid;
	input cfifo_load0;
	wire [`INTWIDTH-1:0] dX_din;
	wire [`INTWIDTH*`CC_N*9-1:0] KP;

	//signal of module MMU_RACC, Please define the input and output by yourself
	
	input RACC_mode;
	input [`VAW-1:0] Y_rd;
	input [`VAW-1:0] Y_wr;
	input [`INTWIDTH*`CORE_N-1:0] Y_din;
	output [`INTWIDTH*`CORE_N-1:0] Y_dout;

	//signal of module MMU_WRAM, Please define the input and output by yourself
	
	
	input [`MAW-1:0] W_rd;
	input [`MAW-1:0] W_wr;
	input [`INTWIDTH*`KSIZE*`CORE_N-1:0] W_din;
	output [`INTWIDTH*`KSIZE*`CORE_N-1:0] W_dout;
	input W_din_valid;
	output W_dout_valid;

	//signal of module MMU_XRAM, Please define the input and output by yourself
	
	
	input [`VAW-1:0] X_rd;
	input [`VAW-1:0] X_wr;
	input [`INTWIDTH-1:0] X_din;
	input X_din_valid;
	output X_dout_valid;

assign RACC_mode = cmd[0];
assign X_dout = cmd[0]?KP:;
	
MMU_BRAM u0(
				.clk(clk),
				.rst_n(rst_n),
				.B_rd(B_rd),
				.B_wr(B_wr),
				.B_din(B_din),
				.B_dout(B_dout),
				.B_din_valid(B_din_valid),
				.B_dout_valid(B_dout_valid),
);

MMU_CFIFO u1(
				.clk(clk),
				.rst_n(rst_n),
				.cfifo_cfg(cfifo_cfg),
				.cfifo_cfg_len(cfifo_cfg_len),
				.cfifo_dvalid(cfifo_dvalid),
				.cfifo_load0(cfifo_load0),
				.dX_din(dX_din),
				.KP(KP),
);

//只能做中间缓存，不能做数据存储
MMU_RACC u2(
				.clk(clk),
				.rst_n(rst_n),
				.RACC_mode(RACC_mode),
				.Y_wr(Y_wr),
				.Y_rd(Y_rd),
				.Y_din(Y_din),
				.Y_dout(Y_dout),
);

MMU_WRAM u3(
				.clk(clk),
				.rst_n(rst_n),
				.W_rd(W_rd),
				.W_wr(W_wr),
				.W_din(W_din),
				.W_dout(W_dout),
				.W_din_valid(W_din_valid),
				.W_dout_valid(W_dout_valid),
);

MMU_XRAM u4(
				.clk(clk),
				.rst_n(rst_n),
				.X_rd(X_rd),
				.X_wr(X_wr),
				.X_din(X_din),
				.X_dout(dX_din),
				.X_din_valid(X_din_valid),
				.X_dout_valid(X_dout_valid),
);



endmodule 



