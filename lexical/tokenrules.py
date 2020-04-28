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
        "STRINGVAL",
        "MOD",
        "INCREMENT",
        'DECREMENT',
        'NOTEQUALS',
        'EQUALS',
        'GREATEREQUALS',
        'LESSEREQUALS',
        ]
# Keywords applicable
reserved = {
        'if' : 'IF',
        'then' : 'THEN',
        'else' : 'ELSE',
        'while' : 'WHILELOOP',
        'execute': 'EXECUTE',
        'for' : 'FORLOOP',
        'print' : 'PRINT',
        'number' : 'INT',
        'string': 'STRING',
        'bool': 'BOOLEAN',
        'true': 'BOOLVALTRUE',
        'false': 'BOOLVALFALSE',
        'not': 'NEGATION',
        'and': 'AND',
        'or': 'OR',
        'in': 'IN',
        'range': 'RANGELOOP'

        }

tokens = basic + list(reserved.values())

# Regular expression rules for simple tokens
t_INCREMENT = r'\+\+'
t_DECREMENT = r'\-\-'
t_EQUALS = r'\=\=' 
t_GREATEREQUALS = r'\>\='
t_LESSEREQUALS = r'\<\='
t_NOTEQUALS = r'\!\='
t_PLUS    = r'\+'
t_MOD     = r'\%'
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
    t.type = 'NUMBER'
    t.value = int(t.value)
    return t

# Define a rule so we can track line numbers
def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

# A string containing ignored characters (spaces and tabs)
t_ignore  = ' \t'
t_ignore_COMMENT_FORWARD_SLASH = r'\/\/.*'
t_ignore_COMMENT_HASH = r'\#.*'

# Error handling rule
def t_error(t):
    print("Illegal character '%s'" % t.value[0])
    t.lexer.skip(1)

def rules():
    return lex.lex()









