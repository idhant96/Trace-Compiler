import os
from lexical import tokenrules

def tokens_test():
    path = '/home/idhant96/projects/SER02-Spring2020-Team22/samples/'
    for filename in os.listdir(path):
        assert tokenrules.get_tokens() == ['execu ']

