% Join two strings to form a new one

join(String1, String2, NewString) :-
    name(String1, L1),
    name(String2, L2),
    append(L1, L2, NewList),
    name(NewString, NewList).

readline(S) :- 
    readline1([], L), 
    name(S, L), 
    !.
    
readline1(OldList, L) :- 
    get0(X), 
    process(OldList, X, L).

process(OldList, 10, OldList).
process(OldList, X, L) :- 
    append(OldList, [X], L1), 
    readline1(L1, L).

readlineF(File, S) :- 
    see(File), 
    readline1([], L), 
    name(S, L), 
    !, 
    seen.

separate(List, Before, After) :- 
    append(Before, [32|After], List),
    !.

findnext(L) :- 
    separate(L, Before, After), 
    proc(Before, After).
findnext(L):- 
    write('Last item is '),
    name(S, L),
    write(S),
    nl.

proc(Before, After) :- 
    write('Next item is '), 
    name(S, Before),
    write(S),
    nl,
    findnext(After).

splitup(S) :-
    name(S, L),
    findnext(L).

startList(L1, L2) :- 
    append(L1, _, L2).

includedList(_, []) :- 
    !,
    fail.
includedList(L1, L2) :- 
    startList(L1, L2).

includedList(L1, [_|L2]) :- 
    includedList(L1, L2).

checkit(L, Plist, present) :- 
    includedList(Plist, L).
checkit(_, _, absent).

checkprolog(X) :- 
    readline(S),
    name(S, L),
    name('Prolog', Plist),
    checkit(L, Plist, X),
    !.