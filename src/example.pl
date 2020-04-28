:- set_prolog_flag(verbose, silent).

:- initialization main.

main :-
    format('Example script~n'),
    current_prolog_flag(argv, Argv),
    format('Called with ~q~n', [Argv]),
    calling(),
    halt.
main :-
    halt(1).


calling() :- split_string("hey how are you", " ", "", L), writeln(L).
