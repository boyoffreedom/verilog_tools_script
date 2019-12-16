import re,os,sys
sys.path.append('../')
from module_analyse import *

signal_list = ['clk','rst_n']
include_list = []

def add_signal_list(signal_list,signal_dict):
    for i in range(1, len(signal_dict) + 1):
        index = str(i)
        if signal_dict[index][2] == 'clk' or signal_dict[index][2] == 'rst_n':
            pass
        else:
            signal_list += [signal_dict[index][2]]

with open('tmp_connection_module.v','w+',encoding='UTF-8') as nf,\
     open('tmp_connection_signal.v','w+',encoding='UTF-8') as sf:
    root = './module/'
    fnames = os.listdir(root)
    file_ob_list = []
    file_index = 0
    for fname in fnames:
        print('\nanalysing '+fname+'...\n')
        with open('./module/'+fname,'r+',encoding='UTF-8') as f:

            inc_list,module_name,para_dict,signal_dict = gen_ins(f,nf,sf,file_index)
            add_signal_list(signal_list,signal_dict)
            if inc_list != []:
                include_list += inc_list
            file_index += 1

#合成打包
with open('connect_top.v', 'w+',encoding='UTF-8') as fw:
    if len(include_list):
        for inc in include_list:
            fw.write('`include '+inc+'\n')
    fw.write('\nmodule top(\n\t\t')
    for i in range(0,len(signal_list)):
        fw.write(signal_list[i] + ',')
        fw.write('\n\t\t')
    fw.write('\n);\n\n\t')
    fw.write('input\tclk;\n\tinput\trst_n;\n')
    with open('tmp_connection_signal.v','r+',encoding='UTF-8') as fcs:
        fw.write(fcs.read().replace('input clk;','').replace('input rst_n;',''))
    os.remove('./tmp_connection_signal.v')
    with open('tmp_connection_module.v','r+',encoding='UTF-8') as fcm:
        fw.write(fcm.read())
    os.remove('./tmp_connection_module.v')
    fw.write('endmodule\n\n\n')
    print('generate top layer file success!\n')