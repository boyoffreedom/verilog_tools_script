`include "config.v"

module CTRL_TOP(	
							clk,rst_n,
							row,col,padding,																	//卷积配置与控制信息
							start,ready,
							din_valid,
							dout_valid,
							dX_addr_rds,dX_addr_rd,											//状态值数据请求
							dW_addr_rds,dW_addr_rd,
							dY_addr_wrs,dY_addr_wr,
							rd_en,
							
							cfifo_cfg,cfifo_cfg_len,cfifo_load0,cfifo_dvalid,
							
							//测试引脚

							row_cnt,col_cnt,kvalid
							);

input clk,rst_n;
input [15:0] row,col;
input padding;

input start;
output ready;
input  din_valid;
output dout_valid;

input 	[`VAW-1:0] 	dX_addr_rds;
output 	[`VAW-1:0] 	dX_addr_rd;

input 	[`MAW-1:0] 	dW_addr_rds;
output 	[`MAW-1:0] 	dW_addr_rd;

input 	[`VAW-1:0] 	dY_addr_wrs;
output 	[`VAW-1:0] 	dY_addr_wr;


output rd_en;

//测试引脚
output [`FIFO_WIDTH-1:0] 	cfifo_cfg_len;
output 							fifo_cfg;
output 							cfifo_dvalid;
output 							cfifo_load0;


output [15:0] row_cnt,col_cnt;
output kvalid;

CONV_CONTROLLER u0(
		.clk(clk),.rst_n(rst_n),
		.row(row),.col(col),.padding(padding),
		.start(start),.ready(ready),
		.din_valid(din_valid),
		.dout_valid(dout_valid),
		
		.dX_addr_rds(dX_addr_rds),.dX_addr_rd(dX_addr_rd),
		.dW_addr_rds(dW_addr_rds),.dW_addr_rd(dW_addr_rd),
		.dY_addr_wrs(dY_addr_wrs),.dY_addr_wr(dY_addr_wr),
		
		.rd_en(rd_en),
		
		//FIFO控制信号
		.cfifo_cfg(cfifo_cfg),.cfifo_cfg_len(cfifo_cfg_len),.cfifo_dvalid(cfifo_dvalid),.cfifo_load0(cfifo_load0),
		//test
		.row_cnt(row_cnt),.col_cnt(col_cnt),.kernel_valid(kvalid)												//测试用信号
);

endmodule
