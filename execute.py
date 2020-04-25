from pyswip import Prolog
from lexical import tokenrules
import sys

'''
TASKS:-
add new token to token list - not wokring for all
join tokenlist to a str and pass it to swi -done partial
pacakge the py code 
make command line extension -done partial
make a token test

'''

# Init prolog
prolog = Prolog()
prolog.consult('./ParseTree.pl')

# get token rules
rules = tokenrules.rules()

#path of file to process
path = sys.argv[1]

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
        if token.type == 'VARIABLE' or token.type == 'STRINGVAL':
            token_string += '{},'.format(token.value)
        else:
            token_string += "\'{}\',".format(token.value)
    return '[' + token_string[0:-1] + '],'

tokens = get_tokens(filepath=path, rules=rules)

final_string = "program(P, " + tokens + " []), eval_program(P) ."

soln = list(prolog.query(final_string))
print(soln)
# for soln in prolog.query(final_string):
#     print(soln)
