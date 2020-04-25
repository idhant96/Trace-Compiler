number_expr(tree_strlen(X))--> [len],['('],string_expr(X),[')'].
number_expr(tree_add(X,Y)) --> number_expr(X), ['+'], level_1(Y).
number_expr(tree_subtract(X,Y)) --> number_expr(X), ['-'], level_1(Y).
number_expr(X) --> level_1(X).

level_1(tree_multiplication(X,Y)) --> level_1(X), ['*'], level_2(Y). 
level_1(tree_division(X,Y)) --> level_1(X), ['/'], level_2(Y).
level_1(tree_mod(X,Y)) --> level_1(X), ['%'], level_2(Y).
level_1(X) --> level_2(X).

level_2(tree_braces(X)) --> ['('], number_expr(X), [')'].
level_2(tree_num(X)) --> number(X).
level_2(tree_variable(X))  --> var_name(X).

eval_numberExp(tree_strlen(X),Env,Scope,Val):- eval_stringExp(X, Env, Scope, Val1), string_length(Val1,Val).
eval_numberExp(tree_add(X,Y), Env, Scope, Val) :- eval_numberExp(X, Env, Scope, Val1), eval_level1(Y, Env, Scope, Val2), Val is Val1 + Val2.
eval_numberExp(tree_subtract(X,Y), Env, Scope, Val) :- eval_numberExp(X, Env, Scope, Val1), eval_level1(Y, Env, Scope, Val2), Val is Val1 - Val2.
eval_numberExp(X, Env, Scope, Val) :- eval_level1(X, Env, Scope, Val).

eval_level1(tree_multiplication(X,Y), Env, Scope, Val) :- eval_numberExp(X, Env, Scope, Val1), eval_level2(Y, Env, Scope, Val2), Val is Val1 * Val2.
eval_level1(tree_division(X,Y), Env, Scope, Val) :- eval_numberExp(X, Env, Scope, Val1), eval_level2(Y, Env, Scope, Val2), Val is Val1 / Val2.
eval_level1(tree_mod(X,Y), Env, Scope, Val) :- eval_numberExp(X, Env, Scope, Val1), eval_level2(Y, Env, Scope, Val2), Val is mod(Val1, Val2).
eval_level1(X, Env, Scope, Val) :- eval_level2(X, Env, Scope, Val).

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
string_expr(tree_concat(X,Y)) --> string_expr(X), ['+'], string_expr(Y).

eval_stringExp(tree_string(X), _, _, X).
eval_stringExp(tree_string_var(X), Env, Scope, Val) :- lookup_for_previous_scope(X, Env, Scope, Val), string(Val).
eval_stringExp(tree_string_var(X), Env, Scope, Val) :- lookup_for_previous_scope(X, Env, Scope, Val), not(string(Val)), write(X), writeln(" Exception: Convert to string"), false.
eval_stringExp(tree_string_var(X), Env, Scope, Val) :- not(lookup_for_previous_scope(X, Env, Scope, Val)), write(X), writeln(" : Variable is not declared"), false.
eval_stringExp(tree_string_concat(X,Y), Env, Scope, Val) :- eval_stringExp(X, Env, Scope, Val1), eval_stringExp(Y, Env, Scope, Val2), string_concat(Val1, Val2, Val).
eval_stringExp(tree_convert_number(X), Env, Scope, Val) :- eval_numberExp(X, Env, Scope, Val1), number_string(Val1, Val).
eval_stringExp(tree_convert_boolean(X), Env, Scope, Val) :- eval_boolExp(X, Env, Scope, Val1), bool_string(Val1, Val).
eval_stringExp(tree_concat(X,Y),Env,Scope,Val):- eval_stringExp(X, Env, Scope, Val1), eval_stringExp(Y, Env, Scope, Val2), string_concat(Val1, Val2, Val).
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

find_scope(Id,Env,Scope,Scope):- Scope > -1, lookup(Id,Env,Scope,_).
find_scope(Id,Env,Scope,ActualScope):- Scope > -1, not(lookup(Id,Env,Scope, _)), Scope1 is Scope -1, find_scope(Id, Env, Scope1, ActualScope).
find_scope(Id,_,Scope,_):- Scope = -1, write(Id), writeln(" : Variable is not declared"), false.
