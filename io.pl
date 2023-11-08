%input/output predicates

reading :- get0(X), process(X).
process(42).
process(X) :- X =\= 42, write(X), nl, reading.

readterms(Infile, Outfile) :- 
    seeing(I), see(Infile), telling(O), tell(Outfile),
    read(T1), write(T1), nl, read(T2), write(T2), nl,
    read(T3), write(T3), nl, read(T4), write(T4), nl,
    seen, see(I), told, tell(O).

words(File, Words) :- see(File), routine(1, Words), seen, !.

routine(Acc, Words) :- 
    get0(X),
    evaluate(X, Acc, Words).

evaluate(-1, Words, Words).
evaluate(X, Acc, Words) :-
    X =:= 10,
    New is Acc + 1,
    routine(New, Words).
evaluate(X, Acc, Words) :-
    X =:= 32,
    New is Acc + 1,
    routine(New, Words).
evaluate(X, Acc, Words) :- 
    X =\= 32,
    X =\= 10,
    routine(Acc, Words).

chars(File, Chars) :- see(File), count(0, Chars), seen, !.

count(Acc, Chars) :- 
    get(X),
    process(X, Acc, Chars).

process(-1, Chars, Chars).
process(33, Acc, Chars) :-
    count(Acc, Chars).
process(34, Acc, Chars) :-
    count(Acc, Chars).
process(40, Acc, Chars) :-
    count(Acc, Chars).
process(41, Acc, Chars) :-
    count(Acc, Chars).
process(44, Acc, Chars) :-
    count(Acc, Chars).
process(46, Acc, Chars) :-
    count(Acc, Chars).
process(58, Acc, Chars) :-
    count(Acc, Chars).
process(59, Acc, Chars) :-
    count(Acc, Chars).
process(63, Acc, Chars) :-
    count(Acc, Chars).
process(X, Acc, Chars) :-
    X =\= -1,
    X =\= 33,
    X =\= 34,
    X =\= 40,
    X =\= 41,
    X =\= 44,
    X =\= 46,
    X =\= 58,
    X =\= 59,
    X =\= 63,
    New is Acc + 1,
    count(New, Chars).

makelower :- get0(X), copyorlower(X), !.
copyorlower(10) :- nl.
copyorlower(X) :-
    X < 65,
    put(X),
    makelower.
copyorlower(X) :-
    X > 90,
    put(X),
    makelower.
copyorlower(X) :-
    X >= 65,
    X =< 90,
    L is X + 32,
    put(L),
    makelower.

copyterms(Input, Output) :- 
    seeing(In), see(Input), 
    telling(Out), tell(Output),
    processing(Input, Output),
    seen, see(In),
    told, tell(Out),
    !.

processing(I, O) :-
    read(X),
    copy(X, I, O).

copy(end, _, _).
copy(X, I, O) :-
    writeq(X),
    put(46),
    nl,
    processing(I, O).

readfile(Input, N) :-
    seeing(Terminal), 
    see(Input),
    fun(Input, N),
    seen,
    see(Terminal),
    !.

fun(_, 0).
fun(Input, N) :-
    get0(X),
    write(X),
    nl,
    New is N - 1,
    fun(Input, New).

combine(Input1, Input2, Output) :-
    see(Input1),
    tell(Output),
    processing(Input1, Output),
    see(Input2),
    tell(Output),
    processing(Input2, Output),
    tell(Output),
    write(end),
    put(46),
    seen, told,
    !.


compare(Input1, Input2) :-
    repeat,
    see(Input1),
    read(Term1),
    see(Input2),
    read(Term2),
    compare_terms(Term1, Term2),
    Term1 == end_of_file,
    write('Reached end_of_file'),
    nl,
    seen, told,
    !.

compare_terms(end_of_file, end_of_file).
compare_terms(First, Second) :-
    First \== end_of_file,
    First == Second,
    write('Terms are identical'),
    nl,
    !.

compare_terms(First, Second) :-
    First \== Second,
    write('Terms are different'),
    nl,
    !.   