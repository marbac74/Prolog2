% Define a last/2 predicate and a last_/3 help predicate that process a list
% to find its last element without leaving any choicepoints (query terminates)
% without needing to tip ";" and get the "false" reply from the toplevel

last([First|Rest], Last) :-
    last_(Rest, First, Last).

last_([], Last, Last).
last_([First|Rest], _, Last) :-
    last_(Rest, First, Last).