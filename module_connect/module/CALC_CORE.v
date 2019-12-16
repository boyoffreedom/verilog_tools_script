`include "config.v"

//arithmetic core

module CALC_CORE(
					clk,rst_n,
					X_din,W_din,
					Y_dout,
);



input clk,rst_n;
input [`INTWIDTH*9*`CORE_N-1:0] X_din,                                                                      W_din;
output [`INTWIDTH*`CORE_N-1:0] Y_dout;

wire [`INTWIDTH*9-1:0] x[`CORE_N-1:0];
wire [`INTWIDTH*9-1:0] w[`CORE_N-1:0];
wire [`INTWIDTH-1:0] y[`CORE_N-1:0];

genvar gv_i;

generate
	for(gv_i = 0; gv_i < `CORE_N; gv_i = gv_i + 1)
	begin:xwy_assign
		assign x[gv_i] = X_din[(gv_i+1)*`INTWIDTH*9-1:gv_i*`INTWIDTH*9];
		assign w[gv_i] = W_din[(gv_i+1)*`INTWIDTH*9-1:gv_i*`INTWIDTH*9];
		assign Y_dout[(gv_i+1)*`INTWIDTH-1:gv_i*`INTWIDTH] = y[gv_i];
	end
endgenerate


generate
	for(gv_i = 0; gv_i < `CORE_N; gv_i = gv_i + 1)
	begin:conv_gen
		MATREE_3x3 uC(	
			.clk(clk),.rst_n(rst_n),
			.x(x[gv_i]),.w(w[gv_i]),.y(y[gv_i])
		);
	end
endgenerate

endmodule

