% File with looping facilities 
loop(0) :- !.
loop(N) :- 
    N > 0, 
    write('The value is: '), 
    write(N), nl,
    M is N-1,
    loop(M).

output_values(Last, Last) :-
    write(Last), 
    nl,
    !.
output_values(First, Last) :-
    First =\= Last,
    write(First), nl,
    New is First + 1,
    output_values(New, Last).

reloop :- 
    write('Type end to end: '),
    read(Word),
    write('Input was '),
    write(Word),
    nl,
    (Word=end; reloop).

get_answer(Ans) :-
    write('Enter answer to question'), nl,
    repeat,
    write('answer yes or no: '),
    read(Ans),
    valid(Ans),
    write('Answer is '),
    write(Ans), nl.

valid(yes). valid(no).

squares(N1, N2) :-
    N1 =:= N2,
    X is N1^2,
    write(X),
    nl,
    !.
squares(N1, N2) :-
    N1 < N2,
    X is N1^2,
    write(X), nl,
    New is N1 + 1,
    squares(New, N2).