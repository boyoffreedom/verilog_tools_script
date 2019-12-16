## ˵�� 

���ǲ�������verilog HDL���ʱ�����ź�̫���ӣ�����������źž޶���λ���ۻ����ң����в���λ�����͵�һ��һ��Ľ��в��ң������ĸ��ź�û�ж���Ҳ������ƫƫ���ǲ鲻���������ģ�ʵ�����5���ӣ���Ŀ����5���¡�SO�������������ͬ���ܵ��ң���Ϊһ��Ӳ����Ƶ��ӹ��������һ�׻���Python��verilog����С���߽ű������׽ű�Ŀ���ǣ�����������ʹ��verilog HDLӲ����ƹ�������Ϊ�ź����ӵȳ���BUG��������˫�ֺ����ӣ�������רע�ڶ���ģ�������ϣ��������޾���λ��ƥ�䣬�����������ź��ظ����壡������

This repo��һ����Python������verilog�����źŽӿ����Ӳ��Ե�һ�ױ����Թ��ߣ�ע�⣺�ű����߱����߱��κη����ۺϹ��ܣ�ʵ��ԭ����ͨ�������ַ�ƥ�佫ģ������֡��ź�IO������������ͷ�ļ���ȡ����������������������ع��������verilog��Ƶı����ԡ�

���׹��ߺ��Ĵ������������������module_analyse.py�ļ��ڣ�**��module_analyse.py�ļ���������û�κ�Ч��**������ʵ�ֲ�ͬ���ܵ��Ǹ��ļ����ڵ�python�ļ������׹���Ŀǰ��Ȼ���Ƿǳ������Ի����Ҵ���һ����BUG���������ʹ��verilog HDL��ƹ�������ʲô���ջ����⣬������ʹ�ñ��׹��߳���BUG�Ļ�������ϵ����QQ��**403466681**����ע����github verilog_tools��

ʹ��ʱ������Ƶ�ģ�����ŵ�����Ҫʹ�ù��ܵ�moduleĿ¼�£���ͬ���ܵĽű������Ѿ����ļ�������ע�����ˣ�module_connectģ������ʵ�ֶ���ײ�ģ��ͬʱ�������ɶ���ģ�飬һ��ʽ��������������ʱ�����ù���test_bench��������ģ���test_benchģ�棬��Ȼ������ЩIDE��������Щ�����������Ҫʹ�õ���������Ļ���Ȼ������Ҫ��дtest_bench��test_module�Ǹ��������ܲ��Ե�ϰ�ߣ�����Ҫ���Ե�ģ���������ź������󣬴�test_moduleģ��������źţ������Ͳ���Ҫ��д�����ӵ�test_benchģ�顣

### �ر�ע�⣺

#### 1���ű����߽����ı��༭�����������ε�ģ�ͱ��룬Ŀ��ּ��һ���̶��Ͽ��Լ��ٿ�������ģ�������Ϻķѵ�ʱ������ľ��������ų������и������Ż����ܣ������ڴ���

#### 2�����ű�Ŀǰֻ֧��verilog HDL���ԡ�
#### 3������ģ���ļ����ڽű�Ŀ¼�µ�module�ļ����ڣ����нű������Զ�������Ӧ��ģ�鹦���ļ���

#### 4�����ű�����ԭ��Python3.5��д��������ⰲװ�κο��ļ���֧�ֲ�ͬ��verilog�﷨��ϣ�ʹ��ǰ�������ϸ���ո�ʽ���д����д�������

#### 5��������Ϊ��Դ���룬�κ��˿ɲ�������ֱ�ӶԴ�������޸�ʹ�ã������˱������������Ȩ����ֱ�ӵ��������Լ����ֻ�������ҵ��;���˽�׷�����Ρ�

#### 

# ����������Ϊ����

##  1��ͷ�ļ�����
�ű�֧��verilogͷ�ļ�������ʽ��eg:`include "config.v"�������������ɶ����ļ�ʱ����ͷ�ļ��ظ���⣬��֤ͷ�ļ���Ψһ��
## 2��ģ�鶨��
������˵����ͨ���ĵײ�ģ���ֱ��ͨ���ű�ִ�еõ���ȷ�Ķ����ļ��������ڱ��˾����ʹ�����ʮ�����ޣ�δ����һ���ԣ�����BUG����ϵ������Ϊ����ͨ������

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

֧���ź�������ģ��������ͬʱ���壬Ҳ�ɵ������塣���ű�֧�ֲ������ݣ�֧���ź�λ����������module������ͬʱ������Ϊ����ģ��

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

## 3���źŶ���

���ź�û����module����ʱ��������Ҫ��֮���ĳ�������壬�ű�֧�ָò����ź����Զ��壬��δ�����κ����⡣

###### eg 3�� 
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

�ýű��������ܵģ�ֻ������޶ȵĽ���λ�������ź�ƴд��������ź�����Ч�ʣ����ɵ�TOP�ļ�������в�С�ĸĶ���ʵ��ģ�͵���ơ�����Ϊͨ���ű����ɵ�TOP�ļ������Կ��������IO�ķ�����Ȼ��Ҫ�û��Լ�ȥ���壬���Ҳ���ģ������Ҳ��Ҫ�����޸ġ�

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

�ű����ܻ����һЩСbug�����ֿ���ֱ��ͨ��commit��QQ��ϵ��403466681
���ű��ɘ����ǳ�(UndefinedAlan)�ṩ�������������õ�RTL�ű�����ʸ��˵�github��https://github.com/boyoffreedom