import ply.lex as lex


# List of token names.   This is always required
basic = [
        'NUMBER',
        'PLUS',
        'MINUS',
        'TIMES',
        'DIVIDE',
        'LPAREN',
        'RPAREN',
        'BLOCKOPEN',
        'BLOCKCLOSE',
        'VARIABLE',
        'DELIMITER',
        'ASSIGNMENT',
        'GREATEROPERATOR',
        'LESSEROPERATOR',
        'DOUBLEQUOTES',
        "STRINGVAL"
        ]
# Keywords applicable
reserved = {
        'if' : 'IF',
        'then' : 'THEN',
        'else' : 'ELSE',
        'while' : 'WHILE',
        'execute': 'EXECUTE',
        'for' : 'FOR',
        'print' : 'PRINT',
        'number' : 'INT',
        'string': 'STRING'
        }

tokens = basic + list(reserved.values())

# Regular expression rules for simple tokens
t_PLUS    = r'\+'
t_MINUS   = r'-'
t_TIMES   = r'\*'
t_DIVIDE  = r'/'
t_ASSIGNMENT  = r'='
t_LPAREN  = r'\('
t_RPAREN  = r'\)'
t_BLOCKOPEN = r'\{'
t_BLOCKCLOSE = r'\}'
t_DELIMITER = r'\;'
t_GREATEROPERATOR = r'>'
t_LESSEROPERATOR = r'<'

#STRINGS
def t_STRING(t):
    r'\".*\"'
    t.type = 'STRINGVAL'
    return t


#Variables
def t_VARIABLE(t):
    r'[a-zA-Z_][a-zA-Z_0-9]*'
    t.type = reserved.get(t.value,'VARIABLE')  
    return t

# A regular expression rule with some action code
def t_NUMBER(t):
    r'\d+'
    t.value = int(t.value)
    return t

# Define a rule so we can track line numbers
def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

# A string containing ignored characters (spaces and tabs)
t_ignore  = ' \t'

# Error handling rule
def t_error(t):
    print("Illegal character '%s'" % t.value[0])
    t.lexer.skip(1)

# Build the lexer
lexer = lex.lex()

def get_tokens(filepath=None):
    if not filepath:
        print('wrong path')
        return None
    f = open(filepath)
    s = str(f.read())
    lexer.input(s)
    # token_list = []
    token_string = ''

    while True:
        token = lexer.token()
        if not token:
            break
        if token.type == 'VARIABLE' or token.type == 'STRINGVAL':
            token_string += '{},'.format(token.value)
        else:
            token_string += "\'{}\',".format(token.value)
        print(token)
    return '[' + token_string[0:-1] + '],'








