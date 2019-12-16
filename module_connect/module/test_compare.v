
//对比多个测试结果，配置好后对比标准结果与模块输出结果
//仅允许在测试时使用！！！！
module test_compare
#(
	parameter DWIDTH = 16,
	parameter MODE  = 0,						//mode == 0 直接比较    mode == 1   相减绝对值对位比较
	parameter N = 4,							//比较数量
	parameter ABDBIT =  4,					//忽略位数，低位忽略位数
	parameter SIGNED = 1						//有符号位
)
(
			input wire [DWIDTH*N-1:0] d0,
			input wire [DWIDTH*N-1:0] d1,
			input wire dvalid,
			output wire [DWIDTH*N-1:0] abs_sub,
			output wire [N-1:0] r,
			output wire error
			
);

wire [N-1:0] r0,r1;

assign error = ((r == {N{1'b1}})?1'b0:1'b1)&dvalid;
assign r = MODE?r1:r0;

wire [DWIDTH-1:0] d0_[N-1:0];
wire [DWIDTH-1:0] d1_[N-1:0];
wire [DWIDTH-1:0] abs_sub_[N-1:0];
wire [DWIDTH-1:0] sub[N-1:0];

genvar gv_i;
generate
	for(gv_i = 0; gv_i < N;gv_i = gv_i + 1)
	begin:r0assign
		assign d0_[gv_i] = d0[DWIDTH*(gv_i+1)-1:DWIDTH*gv_i];
		assign d1_[gv_i] = d1[DWIDTH*(gv_i+1)-1:DWIDTH*gv_i];
		assign abs_sub[DWIDTH*(gv_i+1)-1:DWIDTH*gv_i] = abs_sub_[gv_i];
		
		assign sub[gv_i] = d0_[gv_i] - d1_[gv_i];
		assign abs_sub_[gv_i] = (sub[gv_i][DWIDTH-1] == 1'b1)?({DWIDTH{1'b1}}-sub[gv_i]):sub[gv_i];
		
		assign r0[gv_i] = (d0_[gv_i] == d1_[gv_i])?1'b1:1'b0;
		assign r1[gv_i] = (abs_sub_[gv_i][DWIDTH-1:ABDBIT] == 0)?1'b1:1'b0;
	end
endgenerate

endmodule 
