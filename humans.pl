:- initialization main.

human(ann).
human(george).
human(mike).

main :- 
    bagof(Var, human(Var), List), 
    writeln(List), 
    halt.