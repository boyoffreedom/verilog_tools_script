import re

def module_analyser(file):
    contain = file.read()
    contain = de_command(contain.replace('\t',' '))     #去除COMMAND
    #规则匹配

    ir = re.compile(r'`include.*')                      #头文件规则匹配
    mr = re.compile(r'.*module (.*)\);.*', re.S)        #模块名匹配
    pr = re.compile(r'(#\([^\)]*\))',re.S)              #传递参数匹配
    sr = re.compile(r'input.*|output.*|inout.*')        #IO接口匹配


    incfile_list = re.findall(ir,contain)
    inc_list = []
    for inc in incfile_list:
        inc = inc.replace('`include ','').replace('"','')
        inc_list += [inc]

    module = re.findall(mr, contain)[0]
    module_name = module.split('\n')[0].split('(')[0].replace(' ', '')

    parameter = re.findall(pr, contain)
    if parameter != []:
        parameter = parameter[0]
        para_dict = parameter_analyser(parameter)
    else:
        para_dict = {}

    signal_line = re.findall(sr, contain)
    signal_dict = signal_analyser(signal_line)

    return inc_list,module_name,para_dict,signal_dict

def de_command(string):
    cmd = re.compile(r'/\*.*\*/', re.S)
    command = re.findall(cmd, string)
    command = list(filter(None, command))
    for comm in command:
        string = string.replace(comm, '')
    cmd = re.compile(r'//.*')
    command = re.findall(cmd, string)
    command = list(filter(None, command))
    for comm in command:
        string = string.replace(comm, '')
    return string


def parameter_analyser(string):
    ss = string.replace('#(','').replace(')','').split('\n')
    ss = list((filter(None, ss)))
    paradict = {}
    for eachline in ss:
        paras = eachline.split(',')
        for para in paras:
            if 'parameter' in para:
                para = para.replace('parameter','').replace(' ','').split('=')

                paradict[str(len(paradict)+1)] = [para[0],para[1]]
    return paradict



def signal_analyser(string):
    p1 = re.compile(r'\[(.*?)\]', re.S)  # 最小匹配
    signal_dict = {}
    for eachline in string:
        signal_width = re.findall(p1, eachline)
        signal_width = list(filter(None, signal_width))
        for sw in signal_width:
            sw_ = ''.join(sw.split())  # 压缩信号内部的空格
            eachline = eachline.replace(sw,sw_)



        eachline = eachline.replace('[',' [').replace(']','] ').replace('reg','').replace('wire','').split('//', 1)[0]

        if ';' in eachline:
            eachline = eachline.split(';')
            eachline = list(filter(None,eachline))
        else:
            eachline = eachline.split(',')
            eachline = list(filter(None, eachline))

        for signals in eachline:
            signals = ' '.join(signals.split())  # 压缩空格
            signals = signals.replace(', ',',')

            space_sp = signals.split(' ')
            space_sp = list((filter(None, space_sp)))

            if len(space_sp) < 2:
                continue

            signal_band = re.findall(p1, space_sp[1])
            signal_dir = space_sp[0]
            if signal_dir != 'input' and signal_dir != 'output' and signal_dir != 'inout':
                continue

            if signal_band == []:
                signal_band = '1'
                signal_names = space_sp[1].replace(';','').split(',')
            else:
                signal_band = signal_band[0]
                signal_names = space_sp[2].replace(';','').split(',')

            for signal_name in signal_names:
                dict_index = str(len(signal_dict)+1)
                signal_dict[dict_index] = [signal_dir,signal_band,signal_name]

    return signal_dict

def gen_ins(file_in,ftmpm,ftmps,index):
    inc_list, module_name, para_dict, signal_dict = module_analyser(file_in)
    ftmpm.write('\n'+module_name)
    if para_dict != {}:
        ftmpm.write(' #(\n')
        for ip in range(1,len(para_dict)+1):
            ip = str(ip)
            ftmpm.write('\t.'+para_dict[ip][0]+'('+para_dict[ip][1]+'),\n')
        ftmpm.write(')\n')
    ftmpm.write(' u'+str(index)+'(\n')
    ftmps.write('\n\t//signal of module '+module_name+', Please define the input and output by yourself\n')
    for i in range(1,len(signal_dict)+1):
        ind = str(i)
        ftmpm.write('\t\t\t\t.'+signal_dict[ind][2]+'('+signal_dict[ind][2]+'),\n')
        if signal_dict[ind][1] != '1':
            ftmps.write('\t'+ signal_dict[ind][0] + ' ['+signal_dict[ind][1]+'] '+signal_dict[ind][2]+';\n')
        else:
            ftmps.write('\t'+ signal_dict[ind][0] + ' ' + signal_dict[ind][2] + ';\n')
    ftmpm.write(');\n')
    return inc_list, module_name, para_dict, signal_dict



def signal_recheck(signal_dict,signal_name,signal_dir,signal_band):
    if signal_name in signal_dict:
        if signal_dict[signal_name][1] == signal_band:  # 相同信号
            if signal_dict[signal_name][0] == 'output' and signal_dir == 'output':
                return None
            else:
                #print('Warning:Same signal name both output: ' + '\'' + signal_name + '\'')
                return 1
        else:
            #print('Warning:Same signal name with differ signal bandwidth: ' + '\'' + signal_name + '\'')
            return 2
    else:
        return None
