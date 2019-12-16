`include "config.v"


module fifo2conv_test(	
							clk, rst_n,
							row, col,
							dX_addr_rds,dY_addr_rds,dW_addr_rds,
							padding,start,
							cout_valid,aw,

);

input clk,rst_n;

output reg [15:0] row, col;
output reg padding,start;
input cout_valid;

output reg [`VAW-1:0] dX_addr_rds;
output reg [`VAW-1:0] dY_addr_rds;
output reg [`MAW-1:0] dW_addr_rds;

output [`CORE_N*`INTWIDTH-1:0] aw;

reg [`INTWIDTH-1:0] aw0,aw1,aw2,aw3;
assign aw = {aw3,aw2,aw1,aw0};

reg[3:0] state_c;
reg [9:0] cout_cnt;

reg [`INTWIDTH-1:0] aw0_ram[1023:0]/* synthesis ram_init_file = "./mif/ram_aw0.mif" */;
reg [`INTWIDTH-1:0] aw1_ram[1023:0]/* synthesis ram_init_file = "./mif/ram_aw1.mif" */;
reg [`INTWIDTH-1:0] aw2_ram[1023:0]/* synthesis ram_init_file = "./mif/ram_aw2.mif" */;
reg [`INTWIDTH-1:0] aw3_ram[1023:0]/* synthesis ram_init_file = "./mif/ram_aw3.mif" */;


always @(posedge  clk)begin
	aw0 <= aw0_ram[cout_cnt];
	aw1 <= aw1_ram[cout_cnt];
	aw2 <= aw2_ram[cout_cnt];
	aw3 <= aw3_ram[cout_cnt];
end

always @(negedge clk or negedge rst_n)begin
	if(!rst_n)begin
		cout_cnt <= 1'b0;
	end
	else begin
		if(cout_valid)begin
			cout_cnt <= cout_cnt + 1'b1;
		end
		else begin
			cout_cnt <= cout_cnt;
		end
	end
end

reg[10:0] cnt;

always @(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		state_c <= 0;
	end
	else begin
		case(state_c)
		0:begin
			state_c <= 2;
		end
		1:begin
			state_c <= 0;
		end
		2:begin
			dX_addr_rds <= 0;
			dY_addr_rds <= 0;
			dW_addr_rds <= 0;
			
			row <= 28;
			col <= 28;
			
			padding <= 1'b1;
			
			state_c <= 3;
		end
		3:begin
			start <= 1'b1;
			state_c <= 4;
		end
		4:state_c <= 5;
		5:state_c <= 6;
		6:begin	
			start <= 0;
			cnt <= 0;
			state_c <= 7;
		end
		7:state_c <= 7;

		default : state_c <= 0;
		endcase
	end

end



endmodule 

