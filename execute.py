from lexical import tokenrules
import sys, traceback
import os
import subprocess as sp

# get token rules
rules = tokenrules.rules()

#path of file to process
main_var = sys.argv[1]

# function is used to get tokens for the input program
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

# Extracting required output from terminal finalOutput
# EXP_## and OP_## is used to differentiate exception print statements and normal print statements
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

# Method converts thee input program into tokens.
# The tokens list is used to run swipl command which checks for syntax
# Once syntax is verified another swipl command is run to
def main():
    tokens = get_tokens(filepath=main_var, rules=rules)
    syntax_predicate = "program(P, " + tokens + " [])."
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
        process = sp.Popen(command, stdout=sp.PIPE, stderr=None, shell=True)
        output = process.communicate()
        finalOutput = extractOutput(output[0].decode('utf-8'))
        if len(finalOutput) > 0:
            print(finalOutput)
    except:
        print("[Exception] Internal Error")

    return None

if __name__ == '__main__':
    main()
