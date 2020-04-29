#from pyswip import Prolog
from lexical import tokenrules
import sys, traceback
import os
import subprocess as sp

#os.chdir('/home/idhant96/projects/SER02-Spring2020-Team22/')

'''
TASKS:-
add new token to token list - not wokring for all
join tokenlist to a str and pass it to swi -done
pacakge the py code
make command line extension -done partial
make a token test
'''

# Init prolog
# prolog = Prolog()
# prolog.consult('/Users/rahul5111/Desktop/SER502-Spring2020-Team22/src/project.pl')

# get token rules
rules = tokenrules.rules()

#path of file to process
main_var = sys.argv[1]

def get_tokens(filepath=None, rules=None):
    if not filepath:
        print('wrong path')
        return None
    f = open(filepath)
    s = str(f.read())
    rules.input(s)
    token_string = ''

    while True:
        token = rules.token()
        if not token:
            break
        if token.type == 'STRINGVAL' or token.type == 'NUMBER' :
            token_string += '{},'.format(token.value)
        else:
            token_string += "\'{}\',".format(token.value)
    return '[' + token_string[0:-1] + '],'

def extractOutput(output):
    finalOutput = ""
    spl =output.split("\n")
    if "[EXP_##]" in output:
        for i in spl:
            if "[EXP_##]" in i:
                finalOutput = i.replace("[EXP_##]", "")
                return finalOutput
        return "Exception occured"
    else:
        for i in spl:
            if "[OP_##]" in i:
                finalOutput += i.replace("[OP_##]", "")
                finalOutput += "\n"
        return finalOutput

def main():
    tokens = get_tokens(filepath=main_var, rules=rules)

    #final_string = "program(P, " + tokens + " []), eval_program(P,L), writeln(L)."

    #swipl -s ./src/python_project.pl -g "program(P, ['execute','{','println','(',\"a\",')',';',print,'(',\"the sum \", + , str ,'(', 10,+,12,')',')',';','}'], []), eval_program(P, L), writeln(L)" -g halt

    # print(command)
    #print("command is: " + command)
    # stream = os.popen(command)
    syntax_predicate = "program(P, " + tokens + " [])."
    #print(syntax_predicate)
    syntax_predicate = syntax_predicate.replace('"', '\\"')
    command = 'swipl -s ./src/project.pl -g "' + syntax_predicate + '" -g halt'
    ec, outpu = sp.getstatusoutput(command)
    if ec > 0 :
        print("[Exception]: SyntaxError")
        return None

    eval_predicate = "program(P, " + tokens + " []), eval_program(P)."
    eval_predicate = eval_predicate.replace('"', '\\"')
    command = 'swipl -s ./src/project.pl -g "' + eval_predicate + '" -g halt'
    try:
        #stream = sp.check_output(command, shell=True).decode('utf-8')
        process = sp.Popen(command, stdout=sp.PIPE, stderr=None, shell=True)
        output = process.communicate()
        finalOutput = extractOutput(output[0].decode('utf-8'))
        # input()
        if len(finalOutput) > 0:
            print(finalOutput)
    except:
        print("[Exception] Internal Error")

    # input(stream)
    # output = str(stream)
    # input(stream)


    # soln = list(prolog.query(final_string))
    # if soln:
    #     result = soln[0]['L']
    #
    #     if result:
    #         prints_captured = len(result)
    #         print('results found: ', prints_captured)
    #         print('results converted to utf-8') # check for
    #         result_list= []
    #         for i in range(prints_captured):
    #             res = result[i]
    #             print(res)
    #             result_list.append(res)
    #         return result_list
    return None

if __name__ == '__main__':
    main()
