from pyswip import Prolog
from lexical import tokenrules



'''
TASKS:-
add new token to token list
join tokenlist to a str and pass it to swi
pacakge the py code 
make command line extension
make a token test

'''

path = './samples/sample1.txt'
print('tokens of :', path)



tokens = tokenrules.get_tokens(path)

 # pass args from command line...
# tokens = tokens[0:-1]


prolog = Prolog()
prolog.consult('./ParseTree.pl')


# tokens_string = str(tokens)
# print(tokens_string)
# print(type(tokens_string))

final_string = "program(P, " + tokens + " [])."
print(final_string)
soln = list(prolog.query(final_string))
print(soln)
for soln in prolog.query(final_string):
    print(soln["P"])
