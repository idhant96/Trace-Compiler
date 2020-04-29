#Author : Idhant, Swarnalatha
#Purpose : this file defines the token rules
#Date : 23rd April 2020


import ply.lex as lex


# List of token names.   This is always required
basic = [
        'NUMBER',
        'DECIMAL',
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
        'COMMA',
        'QUESTION',
        'COLON'
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
        'range': 'RANGELOOP',
        'str': 'STR'

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
t_QUESTION = r'\?'
t_COLON = r'\:'
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
    r'\".*?\"'
    t.type = 'STRINGVAL'
    return t


#Variables
def t_VARIABLE(t):
    r'[a-zA-Z_][a-zA-Z_0-9]*'
    t.type = reserved.get(t.value,'VARIABLE')  
    return t

# decimal numbers
def t_DECIMAL(t):
    r'-?\d+\.\d+'
    t.type = 'NUMBER'
    t.value = float(t.value)
    return t

# A regular expression rule with some action code
def t_NUMBER(t):
    r'-?\d+'
    t.type = 'NUMBER'
    t.value = int(t.value)
    return t

t_COMMA = r'\,'
t_MINUS   = r'-'

# Define a rule so we can track line numbers
def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

# A string containing ignored characters (spaces and tabs)
t_ignore  = ' \t'
t_ignore_COMMENT_FORWARD_SLASH = r'\/\/.*'
# t_ignore_COMMENT_HASH = r'\#.*'

# Error handling rule
def t_error(t):
    print("Illegal character '%s'" % t.value[0])
    t.lexer.skip(1)

def rules():
    return lex.lex()










