from pyswip import Prolog
from lexical import tokenrules
import sys

'''
TASKS:-
add new token to token list - not wokring for all
join tokenlist to a str and pass it to swi -done 
pacakge the py code 
make command line extension -done partial
make a token test
'''

# Init prolog
prolog = Prolog()
prolog.consult('./src/python_project.pl')

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


def main():
    tokens = get_tokens(filepath=main_var, rules=rules)

    final_string = "program(P, " + tokens + " []), eval_program(P,L) ."
    print('final query executed: ', final_string)
    soln = list(prolog.query(final_string))
    if soln:
        result = soln[0]['L']

        if result:
            prints_captured = len(result)
            print('results found: ', prints_captured)
            print('results converted to utf-8') # check for
            result_list= []
            for i in range(prints_captured):
                res = result[i]
                print(res)
                result_list.append(res)
            return result_list
    
    print('No result found!')
    return None

if __name__ == '__main__':
    main()
