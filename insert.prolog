:- use_module(library(pce)).
:- dynamic(employee/5).

load :-
    seeing(S),
    see('database.txt'),
    load_data,
    seen,
    see(S).

insert :-
    new(Point, point(100, 100)),
    new(Frame, frame('Inserisci impiegato')),
    new(Dialog, dialog),
    send_list(Dialog, append,
              [ new(N1, text_item(nome)),
                new(N2, text_item(cognome)),
                new(S, menu(sesso)),
                new(A, int_item(età, low := 18, high :=  70)),
                new(D, menu(dipartimento, cycle)),
                button(chiudi, message(Frame, destroy)),
                button(inserisci, (message(@prolog,
                                           assert_employee,
                                           N1?selection,
                                           N2?selection,
                                           S?selection,
                                           A?selection,
                                           D?selection))),
                button(rimuovi, (message(@prolog,
                                         remove_employee,
                                         N1?selection,
                                         N2?selection))),
                button(salva, (message(@prolog,
                                        save_data)))
              ]),
    send_list(S, append, [male, female]),
    send_list(D, append, [research, it_solutions, sales, marketing, human_resources]),
    send(Frame, append(Dialog)),
    send(Frame, open(position := Point)).

load_data :-
    read(Term),
    (   Term == end_of_file
    ->  true
    ;   assertz(Term), load_data
    ).

assert_employee(Name, Family, Sex, Age, Dept) :-
           downcase_atom(Name, Newname),
           downcase_atom(Family, Newfamily),
           assertz(employee(Newname, Newfamily, Sex, Age, Dept)),
           format('Adding ~w ~w to the database ~n',
                  [Name, Family]).

remove_employee(Name, Family) :-
    downcase_atom(Name, Newname),
    downcase_atom(Family, Newfamily),
    retract(employee(Newname, Newfamily, _, _, _)),
    format('Removing ~w ~w from the database ~n', [Name, Family]).

save_data :-
    telling(S),
    tell('database.txt'),
    update,
    told,
    tell(S),
    format('Successfully updated the database file! ~n').

update :-
    employee(Name, Family, Sex, Age, Dept),
    write(employee(Name, Family, Sex, Age, Dept)),
    put(46),
    nl,
    fail.
update.