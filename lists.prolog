% Predicates working with Lists

write_english([]).
write_english([[City, england]| List]) :-
    write(City),
    nl,
    write_english(List).
write_english([_|List]) :-
    write_english(List).

find_largest([First|List], Maxval) :-
    find_biggest(List, Maxval, First).
find_biggest([], LargestSoFar, LargestSoFar).
find_biggest([Head|Tail], Maxval, LargestSoFar) :-
    Head > LargestSoFar,
    find_biggest(Tail, Maxval, Head).
find_biggest([Head|Tail], Maxval, LargestSoFar) :-
    Head =< LargestSoFar,
    find_biggest(Tail, Maxval, LargestSoFar).

front([_], []).
front([Head|Tail], [Head|NewTail]) :- front(Tail, NewTail).

rear([], []).
rear([_|T], T).

inc([], []).
inc([H|T1], [Inc|T2]) :-
    Inc is H + 1,
    inc(T1, T2).

palindrome(List) :-
    reverse(List, Rev),
    Rev == List.

putfirst(Term, List, [Term|List]).

putlast(Term, [], [Term]) :- !.
putlast(Term, [H|T], [H|NewList]) :-
    putlast(Term, T, NewList).

putlast2(Term, List, NewList) :-
    append(List, [Term], NewList).

pred2([], []).
pred2([H|T],[[H]|NewT]) :-
    pred2(T, NewT).

pred2find(Input, Output) :-
    findall([Item], member(Item, Input), Output).

pred3([], []).
pred3([H|T], [pred(H, H)|NewT]) :-
    pred3(T, NewT).

pred3find(Input, Output) :-
    findall(pred(Item, Item), member(Item, Input), Output).

pred4(Input, Output) :-
    findall([element, Item], member(Item, Input), Output).