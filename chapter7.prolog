factorial(1, 1) :- !.
factorial(N, Fact) :-
    N1 is N - 1,
    factorial(N1, Fact1),
    Fact is N * Fact1.

go :-
    repeat,
    write('Enter next number: '),
    read(N),
    check(N, Type),
    write(N),
    write(' is '),
    write(Type),
    nl,
    N =:= 100.

check(N, even) :-
    Half is N / 2,
    integer(Half),
    !.
check(N, odd) :-
    Half is N / 2,
    float(Half),
    !.