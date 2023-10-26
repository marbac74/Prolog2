check_fun([], Updated, Updated).
check_fun([Head|Tail], Previous, Updated) :-
    member(Head, Previous),
    random_between(0, 999, Index),
    atom_concat(Head, Index, NewHead),
    !,
    check_fun(Tail, [NewHead|Previous], Updated).
check_fun([Head|Tail], Previous, Updated) :-
    check_fun(Tail, [Head|Previous], Updated),
    !.