
:- table number_expr/3, level_1/3, level_2/3, bool_expr/3.
%:- use_rendering(svgtree).

program(X)  --> [execute], block(X).

eval_program(P) :- eval_block(P, [], _, 0). 

block(tree_block(X,Y)) --> ['{'], declarationList(X), statementList(Y), ['}'].
eval_block(tree_block(X,Y), Env, EnvR, Scope) :- Scope1 is Scope + 1, eval_declarationList(X, Env, Env1, Scope1), eval_statementList(Y, Env1, Env2, Scope1), deleteScopeVariables(Env2,Scope1, EnvR).  

/* Declaration part */
 %------  
declarationList(tree_declList(X,Y)) --> declaration(X), [';'], declarationList(Y).
declarationList(tree_declList(empty)) --> [].

eval_declarationList(tree_declList(X,Y), Env, EnvR, Scope) :- eval_declaration(X, Env, Env1, Scope), eval_declarationList(Y, Env1, EnvR, Scope).
eval_declarationList(tree_declList(empty), Env, Env, _). 
 %------  
declaration(tree_decl_number(X)) --> numberDeclaration(X).
declaration(tree_decl_boolean(X)) --> booleanDeclaration(X). 
declaration(tree_decl_string(X)) --> stringDeclaration(X).


eval_declaration(tree_decl_number(X),Env,EnvR,Scope):- eval_numberDeclaration(X,Env,EnvR,Scope).
eval_declaration(tree_decl_boolean(X),Env,EnvR,Scope):- eval_booleanDeclaration(X,Env,EnvR,Scope).
eval_declaration(tree_decl_string(X),Env,EnvR,Scope):- eval_stringDeclaration(X,Env,EnvR,Scope).
 %------  
numberDeclaration(tree_numDecl(X,Y)) --> [number], var_name(X), ['='], number_expr(Y).
numberDeclaration(tree_numDecl(X)) --> [number], var_name(X).

eval_numberDeclaration(tree_numDecl(X,Y),Env,EnvR,Scope):- not(lookup(X,Env,Scope,_)), eval_numberExp(Y,Env,Scope, Val), update(X,Val,Scope,Env,EnvR).
eval_numberDeclaration(tree_numDecl(X,_),Env,Env,Scope):- lookup(X,Env,Scope,_),write(X), writeln(" : Variable already declared"), false. 

eval_numberDeclaration(tree_numDecl(X),Env,EnvR,Scope):- not(lookup(X,Env,Scope,_)), update(X,0,Scope,Env,EnvR).
eval_numberDeclaration(tree_numDecl(X),Env,Env,Scope):- lookup(X,Env,Scope,_), write(X),writeln(" : Variable already declared"), false. 
    
 %------   
booleanDeclaration(tree_boolDecl(X,Y)) --> [bool], var_name(X), ['='], bool_expr(Y).
booleanDeclaration(tree_boolDecl(X)) --> [bool], var_name(X).


eval_booleanDeclaration(tree_boolDecl(X,Y),Env,EnvR,Scope):- not(lookup(X,Env,Scope,_)),eval_boolExp(Y,Val, Env,Scope), update(X,Val,Scope,Env, EnvR).
eval_booleanDeclaration(tree_boolDecl(X,_),Env,Env,Scope):- lookup(X,Env,Scope,_), write(X), writeln(" : Variable already declared"), false. 

eval_booleanDeclaration(tree_boolDecl(X),Env,EnvR,Scope):- not(lookup(X,Env,Scope,_)), update(X,false,Scope,Env,EnvR).
eval_booleanDeclaration(tree_boolDecl(X),Env,Env,Scope):- lookup(X,Env,Scope,_), write(X), writeln(" : Variable already declared"), false. 
    
%------    
stringDeclaration(tree_stringDecl(X,Y)) --> [string], var_name(X), ['='], string_expr(Y).
stringDeclaration(tree_stringDecl(X)) --> [string], var_name(X).

eval_stringDeclaration(tree_stringDecl(X,Y),Env,EnvR,Scope):- not(lookup(X,Env,Scope,_)),eval_stringExp(Y, Env,Scope, Val), update(X,Val,Scope,Env,EnvR).
eval_stringDeclaration(tree_stringDecl(X,_),Env,Env,Scope):- lookup(X,Env,Scope,_), writeln(" : Variable already declared"), false. 

eval_stringDeclaration(tree_stringDecl(X),Env,EnvR,Scope):- not(lookup(X,Env,Scope,_)), update(X,"",Scope,Env,EnvR).
eval_stringDeclaration(tree_stringDecl(X),Env,Env,Scope):- lookup(X,Env,Scope,_), write(X), writeln(" : Variable already declared"), false. 
    

%-----

/* Statements part */
statementList(tree_statementList(X,Y)) --> statement(X), [';'], statementList(Y).
statementList(tree_statementList(X,Y)) --> loopStatement(X), statementList(Y).
statementList(tree_statementList(X,Y)) --> conditionalStatement(X), statementList(Y).
statementList(tree_statementList(empty)) --> [].


eval_statementList(tree_statementList(X,Y), Env,EnvR,Scope):-  eval_statement(X,Env,Env1,Scope), eval_statementList(Y,Env1,EnvR,Scope).
eval_statementList(tree_statementList(X,Y),Env,EnvR,Scope):-  eval_loopStatement(X,Env,Env1,Scope), eval_statementList(Y,Env1,EnvR,Scope).
eval_statementList(tree_statementList(X,Y),Env,EnvR,Scope):-  eval_conditionalStatement(X,Env,Env1,Scope), eval_statementList(Y,Env1,EnvR,Scope).
eval_statementList(tree_statementList(empty),Env,Env,_).

%-----
statement(tree_print_statement(X)) --> print_statement(X).
statement(tree_statement_number(X,Y)) --> var_name(X), ['='], number_expr(Y).
statement(tree_statement_bool(X,Y)) --> var_name(X), ['='], bool_expr(Y).
statement(tree_statement_string(X,Y)) --> var_name(X), ['='], string_expr(Y).
statement(tree_statement_increment(X)) --> var_name(X), ['+'], ['+'].
statement(tree_statement_decrement(X)) --> var_name(X), ['-'], ['-'].

eval_statement(tree_print_statement(X), Env,Env,Scope) :- eval_print_statement(X,Env,Scope).
eval_statement(tree_statement_number(X,Y), Env,EnvR,Scope) :-  lookup_for_previous_scope(X,Env,Scope,_), eval_numberExp(Y,Env,Scope,Val), update_for_previous_scope(X,Val,Scope,Env,EnvR).
eval_statement(tree_statement_number(X,_), Env,_,Scope) :-  not(lookup_for_previous_scope(X,Env,Scope,_)), write(X), writeln(" : Variable is not declared"), false.

eval_statement(tree_statement_bool(X,Y), Env,EnvR,Scope) :-  lookup_for_previous_scope(X,Env,Scope,_), eval_boolExp(Y,Val,Env,Scope), update_for_previous_scope(X,Val,Scope,Env,EnvR).
eval_statement(tree_statement_bool(X,_), Env,_,Scope) :-  not(lookup_for_previous_scope(X,Env,Scope,_)), write(X), writeln(" : Variable is not declared"), false.

eval_statement(tree_statement_string(X,Y), Env,EnvR,Scope) :- lookup_for_previous_scope(X,Env,Scope,_), update_for_previous_scope(X, Y, Scope, Env, EnvR).

eval_statement(tree_statement_increment(X), Env,EnvR,Scope) :- eval_statement(tree_statement_number(X,tree_add(X,1)), Env, EnvR, Scope).
eval_statement(tree_statement_decrement(X), Env,EnvR,Scope) :- eval_statement(tree_statement_number(X,tree_subtract(X,1)), Env, EnvR, Scope).

%---

print_statement(tree_print(X)) --> [print],['('], string_expr(X), [')'].
print_statement(tree_println(X)) --> [println],['('], string_expr(X), [')'].

eval_print_statement(tree_print(X), Env, Scope) :- eval_stringExp(X, Env, Scope, Val), write(Val).
eval_print_statement(tree_println(X), Env, Scope) :- eval_stringExp(X, Env, Scope, Val), writeln(Val).

%---

/* Looping Statements -> (for loop, for in range() loop and while loop ) */
loopStatement(tree_simpleFOR(X,Y,Z,A)) --> [for], ['('], declaration(X), [';'], bool_expr(Y) , [';'], statement(Z), [')'], block(A).
loopStatement(tree_rangeFOR(X,Y,Z,A)) --> [for], var_name(X), [in], [range], ['('], number(Y), [','], number(Z) ,[')'], block(A).
loopStatement(tree_while(X,Y)) --> [while],['('], bool_expr(X) ,[')'], block(Y).


eval_loopStatement(tree_simpleFOR(X,Y,Z,A), Env, EnvR, Scope) :- Scope1 is Scope + 1, eval_numberDeclaration(X, Env, Env1, Scope1), 
    eval_loopWithStatement(Y, Z, A, Env1, Env2, Scope1), deleteScopeVariables(Env2,Scope1,EnvR).

eval_loopStatement(tree_rangeFOR(X,Y,Z,A), Env, EnvR, Scope) :- eval_loopStatement(tree_simpleFOR(tree_numDecl(X,Y), tree_lesser(X,Z), tree_statement_increment(X), A), Env, EnvR, Scope). 

eval_loopStatement(tree_while(X,Y),Env,EnvR,Scope):- eval_boolExp(X,Env,Scope,Val),Val = true, eval_block(Y, Env, Env1, Scope),eval_loopStatement(tree_while(X,Y),Env1,EnvR,Scope).
eval_loopStatement(tree_while(X,_),EnvR,EnvR,Scope):- eval_boolExp(X,EnvR,Scope,Val),Val = false.

eval_loopWithStatement(Y, Z, A, Env, EnvR, Scope) :- eval_boolExp(Y, Env, Scope, Val), Val = true, eval_block(A, Env, Env1, Scope), eval_statement(A, Env1, Env2, Scope),
    eval_loopWithStatement(Y, Z, A, Env2, EnvR, Scope).
eval_loopWithStatement(Y, _, _, Env, Env, Scope) :- eval_boolExp(Y, Env, Scope, Val), Val = false.


/* Conditional Statements -> (empty, if then, if then else, if then else if... ) */
conditionalStatement(tree_IF(X,Y)) --> [if], ['('], bool_expr(X) , [')'], [then], block(Y).
conditionalStatement(tree_if_then_else(X,Y,Z)) --> [if], ['('], bool_expr(X) , [')'], [then], block(Y) , [else], [then], block(Z).
conditionalStatement(tree_if_then_else_if(X,Y,Z)) --> [if], ['('], bool_expr(X) , [')'], [then], block(Y) , [else], conditionalStatement(Z).

eval_conditionalStatement(tree_IF(X,Y), Env, EnvR, Scope) :- eval_boolExp(X,Env,Scope,BoolVal), BoolVal = true, eval_block(Y, Env, EnvR, Scope).
eval_conditionalStatement(tree_IF(X,_), Env, Env, Scope) :- eval_boolExp(X,Env,Scope,BoolVal), BoolVal = false.
eval_conditionalStatement(tree_if_then_else(X,Y,_), Env, EnvR, Scope) :- eval_boolExp(X,Env,Scope,BoolVal), BoolVal = true, eval_block(Y, Env, EnvR, Scope).
eval_conditionalStatement(tree_if_then_else(X,_,Z), Env, EnvR, Scope) :- eval_boolExp(X,Env,Scope,BoolVal), BoolVal = false, eval_block(Z, Env, EnvR, Scope).
eval_conditionalStatement(tree_if_then_else_if(X,Y,_), Env, EnvR, Scope) :- eval_boolExp(X,Env,Scope,BoolVal), BoolVal = true, eval_block(Y, Env, EnvR, Scope).
eval_conditionalStatement(tree_if_then_else_if(X,_,Z), Env, EnvR, Scope) :- eval_boolExp(X,Env,Scope,BoolVal), BoolVal = false, eval_conditionalStatement(Z, Env, EnvR, Scope).



number_expr(tree_add(X,Y)) --> number_expr(X), ['+'], level_1(Y).
number_expr(tree_subtract(X,Y)) --> number_expr(X), ['-'], level_1(Y).
number_expr(tree_numExpr(X)) --> level_1(X).

level_1(tree_multiplication(X,Y)) --> level_1(X), ['*'], level_2(Y). 
level_1(tree_division(X,Y)) --> level_1(X), ['/'], level_2(Y).
level_1(tree_numExpr(X)) --> level_2(X).

level_2(tree_braces(X)) --> ['('], number_expr(X), [')'].
level_2(tree_num(X)) --> number(X).
level_2(tree_variable(X))  --> var_name(X).


eval_numberExp(tree_add(X,Y), Env, Scope, Val) :- eval_numberExp(X, Env, Scope, Val1), eval_level1(Y, Env, Scope, Val2), Val is Val1 + Val2.
eval_numberExp(tree_subtract(X,Y), Env, Scope, Val) :- eval_numberExp(X, Env, Scope, Val1), eval_level1(Y, Env, Scope, Val2), Val is Val1 - Val2.
eval_numberExp(tree_numExpr(X), Env, Scope, Val) :- eval_level1(X, Env, Scope, Val).
eval_level1(tree_multiplication(X,Y), Env, Scope, Val) :- eval_numberExp(X, Env, Scope, Val1), eval_level2(Y, Env, Scope, Val2), Val is Val1 * Val2.
eval_level1(tree_division(X,Y), Env, Scope, Val) :- eval_numberExp(X, Env, Scope, Val1), eval_level2(Y, Env, Scope, Val2), Val is Val1 / Val2.
eval_level1(tree_numExpr(X), Env, Scope, Val) :- eval_level2(X, Env, Scope, Val).

eval_level2(tree_braces(X), Env, Scope, Val) :- eval_numberExp(X, Env, Scope, Val).
eval_level2(tree_num(X), _, _, X).
eval_level2(tree_variable(X), Env, Scope, Val) :- eval_variable(X, Env, Scope, Val).



/* Boolean Expression -> (true, false, not, and ,or, ==, !=, >, <, >=, <=) */


bool_expr(tree_not(X)) --> [not], bool_expr(X).
bool_expr(tree_and(X,Y)) --> bool_expr(X), [and] , bool_expr(Y).
bool_expr(tree_or(X,Y)) --> bool_expr(X), [or] , bool_expr(Y).
bool_expr(tree_equalityNum(X,Y)) --> number_expr(X), ['='], ['='], number_expr(Y).
bool_expr(tree_notEqualNum(X,Y)) --> number_expr(X), ['!'], ['='], number_expr(Y).
bool_expr(tree_greater(X,Y)) --> number_expr(X), ['>'], number_expr(Y).
bool_expr(tree_lesser(X,Y)) --> number_expr(X), ['<'], number_expr(Y).
bool_expr(tree_greaterOrEq(X,Y)) --> number_expr(X), ['>'], ['='], number_expr(Y).
bool_expr(tree_lesserOrEq(X,Y)) --> number_expr(X), ['<'], ['='], number_expr(Y).
bool_expr(tree_equalityString(X,Y)) --> string_expr(X), ['='], ['='], string_expr(Y).
bool_expr(tree_notEqualString(X,Y)) --> string_expr(X), ['!'], ['='], string_expr(Y).
bool_expr(tree_equalityBool(X,Y)) --> bool_expr(X), ['='], ['='], bool_expr(Y).
bool_expr(tree_notEqualBool(X,Y)) --> bool_expr(X), ['!'], ['='], bool_expr(Y).



bool_expr(tree_variable(X))  --> var_name(X).
bool_expr(tree_true(true)) --> ['true'].
bool_expr(tree_false(false)) --> ['false'].



eval_boolExp(t_boolean(true), _, _, true).
eval_boolExp(t_boolean(false), _, _, false).
eval_boolExp(t_variable(X), Env, Scope, Val) :- eval_variable(X, Env, Scope, Val).

eval_boolExp(tree_not(X), Env, Scope, Val) :- eval_boolExp(X, Env, Scope, Val1), eval_boolean_not(Val1, Env, Scope, Val).

eval_boolExp(tree_and(X,Y), Env, Scope, Val) :- eval_boolExp(X, Env, Scope, Val1), Val1 = true, eval_boolExp(Y, Env, Scope, Val).
eval_boolExp(tree_and(X,_), Env, Scope, Val) :- eval_boolExp(X, Env, Scope, Val1), Val1 = false, Val = false.

eval_boolExp(tree_or(X,_), Env, Scope, Val) :- eval_boolExp(X, Env, Scope, Val1), Val1 = true, Val = true.
eval_boolExp(tree_or(X,Y), Env, Scope, Val) :- eval_boolExp(X, Env, Scope, Val1), Val1 = false, eval_boolExp(Y, Env, Scope, Val).

eval_boolExp(tree_equalityNum(X,Y), Env, Scope, Val) :- eval_numberExp(X, Env, Scope, Val1), eval_numberExp(Y, Env, Scope, Val2), Val1 = Val2, Val = true.
eval_boolExp(tree_equalityNum(X,Y), Env, Scope, Val) :- eval_numberExp(X, Env, Scope, Val1), eval_numberExp(Y, Env, Scope, Val2), Val1 \= Val2, Val = false.

eval_boolExp(tree_equalityBool(X,Y), Env, Scope, Val) :- eval_boolExp(X, Env, Scope, Val1), eval_boolExp(Y, Env, Scope, Val2), Val1 = Val2, Val = true.
eval_boolExp(tree_equalityBool(X,Y), Env, Scope, Val) :- eval_boolExp(X, Env, Scope, Val1), eval_boolExp(Y, Env, Scope, Val2), Val1 \= Val2, Val = false.

eval_boolExp(tree_equalityString(X,Y), Env, Scope, Val) :- eval_stringExp(X, Env, Scope, Val1), eval_stringExp(Y, Env, Scope, Val2), Val1 = Val2, Val = true.
eval_boolExp(tree_equalityString(X,Y), Env, Scope, Val) :- eval_stringExp(X, Env, Scope, Val1), eval_stringExp(Y, Env, Scope, Val2), Val1 \= Val2, Val = false.

eval_boolExp(tree_notEqualNum(X,Y), Env, Scope, Val) :- eval_numberExp(X, Env, Scope, Val1), eval_numberExp(Y, Env, Scope, Val2), Val1 = Val2, Val = false.
eval_boolExp(tree_notEqualNum(X,Y), Env, Scope, Val) :- eval_numberExp(X, Env, Scope, Val1), eval_numberExp(Y, Env, Scope, Val2), Val1 \= Val2, Val = true.

eval_boolExp(tree_notEqualBool(X,Y), Env, Scope, Val) :- eval_boolExp(X, Env, Scope, Val1), eval_boolExp(Y, Env, Scope, Val2), Val1 = Val2, Val = false.
eval_boolExp(tree_notEqualBool(X,Y), Env, Scope, Val) :- eval_boolExp(X, Env, Scope, Val1), eval_boolExp(Y, Env, Scope, Val2), Val1 \= Val2, Val = true.

eval_boolExp(tree_notEqualString(X,Y), Env, Scope, Val) :- eval_stringExp(X, Env, Scope, Val1), eval_stringExp(Y, Env, Scope, Val2), Val1 = Val2, Val = false.
eval_boolExp(tree_notEqualString(X,Y), Env, Scope, Val) :- eval_stringExp(X, Env, Scope, Val1), eval_stringExp(Y, Env, Scope, Val2), Val1 \= Val2, Val = true.

eval_boolExp(tree_greater(X,Y), Env, Scope, Val) :- eval_numberExp(X, Env, Scope, Val1), eval_numberExp(Y, Env, Scope, Val2), Val1 > Val2, Val = true.
eval_boolExp(tree_greater(X,Y), Env, Scope, Val) :- eval_numberExp(X, Env, Scope, Val1), eval_numberExp(Y, Env, Scope, Val2), Val1 =< Val2, Val = false.

eval_boolExp(tree_lesser(X,Y), Env, Scope, Val) :- eval_numberExp(X, Env, Scope, Val1), eval_numberExp(Y, Env, Scope, Val2), Val1 < Val2, Val = true.
eval_boolExp(tree_lesser(X,Y), Env, Scope, Val) :- eval_numberExp(X, Env, Scope, Val1), eval_numberExp(Y, Env, Scope, Val2), Val1 >= Val2, Val = false.

eval_boolExp(tree_greaterOrEq(X,Y), Env, Scope, Val) :- eval_numberExp(X, Env, Scope, Val1), eval_numberExp(Y, Env, Scope, Val2), Val1 >= Val2, Val = true.
eval_boolExp(tree_greaterOrEq(X,Y), Env, Scope, Val) :- eval_numberExp(X, Env, Scope, Val1), eval_numberExp(Y, Env, Scope, Val2), Val1 < Val2, Val = false.

eval_boolExp(tree_lesserOrEq(X,Y), Env, Scope, Val) :- eval_numberExp(X, Env, Scope, Val1), eval_numberExp(Y, Env, Scope, Val2), Val1 =< Val2, Val = true.
eval_boolExp(tree_lesserOrEq(X,Y), Env, Scope, Val) :- eval_numberExp(X, Env, Scope, Val1), eval_numberExp(Y, Env, Scope, Val2), Val1 > Val2, Val = false.


eval_boolean_not(true,_,_,false).
eval_boolean_not(false,_,_,true).


/* String Expression -> checks for string type.*/
string_expr(tree_string(X)) --> string(X).
string_expr(tree_string_var(X)) --> var_name(X).
%string_expr(tree_string_concat(X, Y)) --> string_expr(X), ['+'], string_expr(Y).
% Need to do somethting aboouot this
string_expr(tree_convert_number(X)) --> [str],['('], number_expr(X), [')'].
string_expr(tree_convert_boolean(X)) --> [str],['('], bool_expr(X), [')'].

eval_stringExp(tree_string(X), _, _, X).
eval_stringExp(tree_string_var(X), Env, Scope, Val) :- lookup_for_previous_scope(X, Env, Scope, Val).
eval_stringExp(tree_string_var(X), Env, Scope, Val) :- not(lookup_for_previous_scope(X, Env, Scope, Val)), write(X), writeln(" : Variable is not declared"), false.
eval_stringExp(tree_string_concat(X,Y), Env, Scope, Val) :- eval_stringExp(X, Env, Scope, Val1), eval_stringExp(Y, Env, Scope, Val2), string_concat(Val1, Val2, Val).
eval_stringExp(tree_convert_number(X), Env, Scope, Val) :- eval_numberExp(X, Env, Scope, Val1), number_string(Val1, Val).
eval_stringExp(tree_convert_boolean(X), Env, Scope, Val) :- eval_boolExp(X, Env, Scope, Val1), bool_string(Val1, Val).
bool_string(true, "true").
bool_string(false, "false").

var_name(X) --> [X], {atom(X)}.
eval_variable(X, Env, Scope, Val) :- lookup_for_previous_scope(X, Env, Scope, Val).
eval_variable(X, Env, Scope, Val) :- not(lookup_for_previous_scope(X, Env, Scope, Val)), write(X), writeln(" : Variable is not declared"), false.

/* primitive types */
number(X) --> [X], {number(X)}.
string(X) --> [X], {string(X)}.


deleteScopeVariables(Env,Scope,EnvR) :- deleteScopeVariables(Env,Scope,[],EnvR).
deleteScopeVariables([H|T],Scope,Env1,EnvR):- H \= (_, _, Scope), deleteScopeVariables(T,Scope, [H|Env1],EnvR).
deleteScopeVariables([(_,_,Scope)|T],Scope,Env1,EnvR):- deleteScopeVariables(T,Scope,Env1,EnvR).
deleteScopeVariables([], _, EnvR, EnvR).

% predicate to look up a variable value from an environment.
lookup(Id, [(Id, Val, Scope)|_], Scope,Val).
lookup(Id,[_|T], Scope, Val) :- lookup(Id, T, Scope, Val).

lookup_for_previous_scope(Id,Env,Scope,Val):- Scope > -1, lookup(Id,Env,Scope,Val).
lookup_for_previous_scope(Id,Env,Scope,Val):- Scope > -1, not(lookup(Id,Env,Scope, _)), Scope1 is Scope -1, lookup_for_previous_scope(Id, Env, Scope1, Val).
% predicate to update a variable from environment and add to new environment.

update(Id, Val, Scope, [], [(Id, Val, Scope)]).
update(Id, Val, Scope, [(Id, _, Scope)|T], [(Id, Val, Scope)|T]).
update(Id, Val, Scope, [H|T], [H|R]) :- H \= (Id, _, Scope), update(Id, Val, Scope, T, R).

update_for_previous_scope(Id, Val, Scope, Env, EnvR) :- update(Id, Val, Scope, Env, EnvR).
update_for_previous_scope(Id, Val, Scope, Env, EnvR) :- not(update(Id, Val, Scope, Env, _)), Scope1 is Scope -1, update_for_previous_scope(Id, Val, Env, Scope1, EnvR).
