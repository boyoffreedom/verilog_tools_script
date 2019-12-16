import os,sys
sys.path.append('../')
from module_analyse import *

signal_list = []
include_list = []

root = './module/'
fnames = os.listdir(root)
file_ob_list = []
file_index = 0
#delete all prefore file

flist = os.listdir('./test_module/')
for f in flist:
    filepath = os.path.join('./test_module/',f)
    if os.path.isfile(filepath):            #判断该文件是否为文件或者文件夹
        os.remove(filepath)                 #若为文件，则直接删除
    elif os.path.isdir(filepath):
        shutil.rmtree(filepath,True)        #若为文件夹，则删除该文件夹及文件夹内所有文件

for fname in fnames:
    print(fname)
    with open('./module/'+fname,'r+',encoding='UTF-8') as f,\
        open('./test_module/test_'+fname,'w+',encoding='UTF-8') as nf:
        include_list,module_name,para_dict,signal_dict = module_analyser(f)
        if include_list != []:
            for inc in include_list:
                nf.write('`include \"'+inc+'\"\n')
        nf.write('\nmodule test_' + module_name)
        if para_dict != {}:
            nf.write(' #(\n')
            for ip in range(1, len(para_dict) + 1):
                ip = str(ip)
                nf.write('\t' + para_dict[ip][0] + '= ' + para_dict[ip][1] + ',\n')
                nf.write(')\n')
        nf.write('(\n\tinput wire clk,\n\tinput wire rst_n,\n')
        for i in range(1, len(signal_dict) + 1):
            ind = str(i)
            if signal_dict[ind][2] != 'clk' and signal_dict[ind][2] != 'rst_n':
                if signal_dict[ind][0] == 'input':
                    nf.write('\toutput reg ')
                elif signal_dict[ind][0] == 'output':
                    nf.write('\tinput wire ')

                if signal_dict[ind][1] != '1':
                    nf.write('[' + signal_dict[ind][1] + '] ' + signal_dict[ind][2] + ',\n')
                else:
                    nf.write(signal_dict[ind][2] + ',\n')

        nf.write(');\n\n\n\nendmodule\n\n')
