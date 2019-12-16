## 说明 

你是不是有在verilog HDL设计时觉得信号太复杂，层层例化后信号巨多且位宽眼花缭乱，稍有不慎位宽出错就得一层一层的进行查找，或者哪个信号没有定义也不报错，偏偏就是查不出问题在哪，实际设计5分钟，项目调试5个月。SO！！！！与你感同身受的我，作为一名硬件设计电子狗，设计了一套基于Python的verilog适用小工具脚本，这套脚本目标是，尽量减少在使用verilog HDL硬件设计过程中因为信号连接等出现BUG，解放你的双手和脑子！将精力专注在对于模块的设计上，而不是无尽的位宽匹配，层层例化后的信号重复定义！！！！

This repo是一个用Python开发的verilog代码信号接口连接测试的一套便利性工具，注意：脚本工具本身不具备任何分析综合功能，实现原理是通过正则字符匹配将模块的名字、信号IO、参数、包含头文件提取出来，后续将继续增加相关功能以提高verilog设计的便利性。

本套工具核心代码分析处理函数均放在module_analyse.py文件内，**但module_analyse.py文件本身运行没任何效果**，真正实现不同功能的是各文件夹内的python文件。本套工具目前仍然不是非常的人性化，且存在一定的BUG，如果您在使用verilog HDL设计过程中有什么烦恼或问题，或者在使用本套工具出现BUG的话，请联系本人QQ：**403466681**，备注来自github verilog_tools。

使用时将所设计的模块代码放到你需要使用功能的module目录下，不同功能的脚本工具已经由文件夹名标注出来了，module_connect模块用于实现多个底层模块同时例化生成顶层模块，一键式例化，降低例化时的无用功。test_bench用于生成模块的test_bench模版，虽然可能有些IDE适配了这些东西，但如果要使用第三方仿真的话仍然还是需要编写test_bench。test_module是个人做功能测试的习惯，将需要测试的模块例化，信号引出后，从test_module模块给激励信号，这样就不需要编写更复杂的test_bench模块。

### 特别注意：

#### 1、脚本工具仅是文本编辑，不进行深层次的模型编译，工具只是半自动化设计的，设计完之后必须再由人工指向信号方向才能正确使用，设计这套工具的目的在于一定程度上减少开发者在模块连接上耗费的时间与查错的精力，不排除后续有更深层的优化可能，敬请期待。

#### 2、本脚本目前只支持verilog HDL语言。
#### 3、将各模块文件放在脚本目录下的module文件夹内，运行脚本，将自动创建对应的模块功能文件。

#### 4、本脚本基于原生Python3.5编写，无需额外安装任何库文件，支持不同的verilog语法组合！

#### 5、本代码为开源代码，任何人可不经允许直接对代码进行修改使用，但本人保留代码的所有权，如直接盗用署上自己名字或用于商业用途本人将追究责任。

#### 

# 以例化连接为例：

##  1、头文件包含
脚本支持verilog头文件包含格式（eg:`include "config.v"），并会在生成顶层文件时进行头文件重复检测，保证头文件的唯一性
## 2、模块定义
正常来说编译通过的底层模块可直接通过脚本执行得到正确的顶层文件，但由于本人精力和代码风格十分有限，未能逐一测试，如有BUG请联系。以下为测试通过案例

###### eg 1:

```verilog
module test_controller(
		clk,rst_n,
		matrix_m,matrix_n,
		addr_rdsv,addr_rdsm,addr_wrsv,
		start,ready,
		addr_rdv,addr_wrv,
		addr_rdm,
		dout_v,dout_m,dout_y,
		dout_valid
);
```

支持信号属性在模块申明的同时定义，也可单独定义。本脚本支持参数传递，支持信号位宽描述放在module声明的同时。以下为范例模型

###### eg 2:

```verilog
module test_compare
#(
    parameter DWIDTH = 16,
    parameter MODE  = 0,						
    parameter N = 4,
    parameter ABDBIT =  4
)
(
			input wire [DWIDTH*N-1:0] d0,	
			input wire [DWIDTH*N-1:0] d1,
			input wire dvalid,
			output wire [DWIDTH*N-1:0] abs_sub,
			output wire [N-1:0] r,
			output wire error
);
```

## 3、信号定义

当信号没有在module声明时定义则需要在之后的某个区域定义，脚本支持该部分信号属性定义，暂未发现任何问题。

###### eg 3： 
```verilog
input clk,rst_n;
output [15:0] matrix_m,matrix_n;
output[21:0] addr_rdsv,addr_wrsv;
output[19:0] addr_rdsm;
output start;
input ready;
input dout_valid;

input [21:0] addr_rdv,addr_wrv;
input [19:0] addr_rdm;

output [`INTWIDTH-1:0] dout_v;
output [4*`INTWIDTH-1:0] dout_m;
```

该脚本不是万能的，只能最大限度的降低位宽错误和信号拼写错误，提高信号连接效率，生成的TOP文件仍需进行不小的改动以实现模型的设计。以下为通过脚本生成的TOP文件，可以看到顶层的IO的方向仍然需要用户自己去定义，并且部分模块连线也需要进行修改。

###### eg 4:  

```verilog
`include "config.v"

module top(
		clk,
		rst_n,
		matrix_m,
		matrix_n,
		addr_rdsv,
		addr_rdsm,
		addr_wrsv,
		start,
		ready,
		addr_rdv,
		addr_wrv,
		addr_rdm,
		dout_v,
		dout_m,
		dout_y,
		dout_valid,
		d0,
		d1,
		dvalid,
		abs_sub,
		r,
		error,
		
);

	input clk,rst_n;

//signal of fc_test.v
	

	wire [15:0] matrix_m,matrix_n;
	wire [21:0] addr_rdsv,addr_wrsv;
	wire [19:0] addr_rdsm;
	wire start;									//MVMPU start ready
	wire ready;									//MVMPU ready
	wire dout_valid;
	wire [21:0] addr_rdv,addr_wrv;
	wire [19:0] addr_rdm;
	wire [`INTWIDTH-1:0] dout_v;
	wire [4*`INTWIDTH-1:0] dout_m;
	wire [4*`INTWIDTH-1:0] dout_y;

//signal of test_compare.v
	wire [DWIDTH*N-1:0] d0;
	wire [DWIDTH*N-1:0] d1;
	wire dvalid;
	wire [DWIDTH*N-1:0] abs_sub;
	wire [N-1:0] r;
	wire error;

//signal of test_compare.v

test_controller u0(
		.clk(clk),
		.rst_n(rst_n),
		.matrix_m(matrix_m),
		.matrix_n(matrix_n),
		.addr_rdsv(addr_rdsv),
		.addr_rdsm(addr_rdsm),
		.addr_wrsv(addr_wrsv),
		.start(start),
		.ready(ready),
		.addr_rdv(addr_rdv),
		.addr_wrv(addr_wrv),
		.addr_rdm(addr_rdm),
		.dout_v(dout_v),
		.dout_m(dout_m),
		.dout_y(dout_y),
		.dout_valid(dout_valid),
);

test_compare
#(
	.DWIDTH(16),
	.MODE(0),
	.N(4),
	.ABDBIT(4),
)
u1(
	.d0(d0),
	.d1(d1),
	.dvalid(dvalid),
	.abs_sub(abs_sub),
	.r(r),
	.error(error),
);


endmodule
```

脚本可能会存在一些小bug，发现可以直接通过commit或QQ联系：403466681
本脚本由樂落星辰(UndefinedAlan)提供，另有其他好用的RTL脚本请访问个人的github：https://github.com/boyoffreedom
