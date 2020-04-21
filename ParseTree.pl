:- table number_expr/3, level_1/3, bool_expr/3.
:- use_rendering(svgtree).

program(X)  --> [execute], block(X).
block(tree_block(X,Y)) --> ['{'], declarationList(X), statementList(Y), ['}'].

/*Idhant*/
/* Declaration part */
declarationList(tree_declList(X,Y)) --> declaration(X), [';'], declarationList(Y).
declarationList(tree_declList(empty)) --> [].

declaration(tree_decl(X)) --> numberDeclaration(X).
declaration(tree_decl(X)) --> booleanDeclaration(X). 
declaration(tree_decl(X)) --> stringDeclaration(X).

numberDeclaration(tree_numDecl(X,Y)) --> [number], var_name(X), ['='], number_expr(Y).
numberDeclaration(tree_numDecl(X)) --> [number], var_name(X).

booleanDeclaration(tree_boolDecl(X,Y)) --> [bool], var_name(X), ['='], bool_expr(Y).
booleanDeclaration(tree_boolDecl(X)) --> [bool], var_name(X).

stringDeclaration(tree_stringDecl(X,Y)) --> [string], var_name(X), ['='], string_expr(Y).
stringDeclaration(tree_stringDecl(X)) --> [string], var_name(X).

/* Statements part */
statementList(tree_statementList(X,Y)) --> statement(X), [';'], statementList(Y).
statementList(tree_statementList(X,Y)) --> loopStatement(X), statementList(Y).
statementList(tree_statementList(X,Y)) --> conditionalStatement(X), statementList(Y).
statementList(tree_statementList(empty)) --> [].

statement(tree_statement(X)) --> print_statement(X).
statement(tree_statement(X,Y)) --> var_name(X), ['='], number_expr(Y).
statement(tree_statement(X,Y)) --> var_name(X), ['='], bool_expr(Y).
statement(tree_statement(X,Y)) --> var_name(X), ['='], string_expr(Y).
statement(tree_statement(X)) --> var_name(X), ['+'], ['+'].
statement(tree_statement(X)) --> var_name(X), ['-'], ['-'].


print_statement(tree_print(X)) --> [print],['('], string_expr(X), [')'].

/* Looping Statements -> (for loop, for in range() loop and while loop ) */
loopStatement(tree_simpleFOR(X,Y,Z,A)) --> [for], ['('], declaration(X), [';'], bool_expr(Y) , [';'], statement(Z), [')'], block(A).
loopStatement(tree_rangeFOR(X,Y,Z,A)) --> [for], var_name(X), [in], [range], ['('], number(Y), [','], number(Z) ,[')'], block(A).
loopStatement(tree_rangeFOR(X,Y)) --> [while],['('], bool_expr(X) ,[')'], block(Y).

/* Conditional Statements -> (empty, if then, if then else, if then else if... ) */
conditionalStatement(tree_simpleIF(X,Y)) --> [if], ['('], bool_expr(X) , [')'], [then], block(Y).
conditionalStatement(tree_simpleIfELSE(X,Y,Z)) --> [if], ['('], bool_expr(X) , [')'], [then], block(Y) , [else], [then], block(Z).
conditionalStatement(tree_simpleIfELSE(X,Y,Z)) --> [if], ['('], bool_expr(X) , [')'], [then], block(Y) , [else], conditionalStatement(Z).

/* Number Expression -> (/,*,+,-) */
number_expr(tree_numExpr(X)) --> level_1(X).
number_expr(tree_add(X,Y)) --> number_expr(X), ['+'], level_1(Y).
number_expr(tree_subtract(X,Y)) --> number_expr(X), ['-'], level_1(Y).
level_1(tree_multiplication(X,Y)) --> level_1(X), ['*'], level_2(Y). 
level_1(tree_division(X,Y)) --> level_1(X), ['/'], level_2(Y).
level_1(tree_numExpr(X)) --> level_2(X).
level_2(tree_braces(X)) --> ['('], number_expr(X), [')'].
level_2(tree_num(X)) --> number(X).
level_2(tree_variable(X))  --> var_name(X).


/* Boolean Expression -> (true, false, not, and ,or, ==, !=, >, <, >=, <=) */
bool_expr(tree_true(true)) --> ['true'].
bool_expr(tree_false(false)) --> ['false'].
bool_expr(tree_not(X)) --> [not], bool_expr(X).
bool_expr(tree_and(X,Y)) --> bool_expr(X), [and] , bool_expr(Y).
bool_expr(tree_or(X,Y)) --> bool_expr(X), [or] , bool_expr(Y).
bool_expr(tree_equalityNum(X,Y)) --> number_expr(X), ['='], ['='], number_expr(Y).
bool_expr(tree_equalityBool(X,Y)) --> bool_expr(X), ['='], ['='], bool_expr(Y).
bool_expr(tree_equalityString(X,Y)) --> string_expr(X), ['='], ['='], string_expr(Y).
bool_expr(tree_notEqualNum(X,Y)) --> number_expr(X), ['!'], ['='], number_expr(Y).
bool_expr(tree_notEqualBool(X,Y)) --> bool_expr(X), ['!'], ['='], bool_expr(Y).
bool_expr(tree_notEqualString(X,Y)) --> string_expr(X), ['!'], ['='], string_expr(Y).

bool_expr(tree_greater(X,Y)) --> number_expr(X), ['>'], number_expr(Y).
bool_expr(tree_lesser(X,Y)) --> number_expr(X), ['<'], number_expr(Y).
bool_expr(tree_greaterOrEq(X,Y)) --> number_expr(X), ['>'], ['='], number_expr(Y).
bool_expr(tree_lesserOrEq(X,Y)) --> number_expr(X), ['<'], ['='], number_expr(Y).

/* String Expression -> checks for string type.*/
string_expr(tree_string(X)) --> string(X).
var_name(X) --> [X], {atom(X)}.

/* primitive types */
number(X) --> [X], {number(X)}.
string(X) --> [X], {string(X)}.


