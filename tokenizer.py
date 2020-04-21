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
   'DELIMITER'
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
   'number' : 'INT'
}

tokens = basic + list(reserved.values())

# Regular expression rules for simple tokens
t_PLUS    = r'\+'
t_MINUS   = r'-'
t_TIMES   = r'\*'
t_DIVIDE  = r'/'
t_LPAREN  = r'\('
t_RPAREN  = r'\)'
t_BLOCKOPEN = r'\{'
t_BLOCKCLOSE = r'\}'
t_DELIMITER = r'\;'

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


f = open('./demo.txt')

s = str(f.read())


lexer.input(s)

token_lsit = []

while True:
    token = lexer.token()
    if not token:
        break
    # print(token.value)
    token_lsit.append(token.value)
    
print(token_lsit)
    
