:- use_module(library(pce)).

display :-
    new(P, point(100, 100)),
    new(F, frame('Ricerca')),
    new(D, dialog),
    new(T1, text_item(nome)),
    new(T2, text_item(cognome)),
    send(D, append, T1),
    send(D, append, T2),
    send(D, append, button(cerca, message(@prolog, cerca, T1, T2))),
    send(D, append, button(chiudi, message(@prolog, fine, F))),
    send(F, append(D)),
    send(F, open(position := P)).

cerca(T1, T2) :-
    get(T1, value, Nome),
    get(T2, value, Cognome),
    downcase_atom(Nome, Nuovonome),
    downcase_atom(Cognome, Nuovocognome),
    seeing(S),
    see('database.txt'),
    db_search(Nuovonome, Nuovocognome),
    seen,
    see(S).

db_search(Nome, Cognome) :-
    read(Record),
    (   Record = employee(Nome, Cognome, Sesso, Età, Dipartimento)
    ->  new(P, point(400, 100)),
        new(F, frame('Dati impiegato')),
        new(D1, dialog),
        send_list(D1, append,
                  [new(N, text_item(nome)),
                   new(C, text_item(cognome)),
                   new(S, text_item(sesso)),
                   new(E, text_item(età)),
                   new(Dip, text_item(dipartimento)),
                   new(_, button(chiudi, message(@prolog, fine, F)))
                  ]),
        send(N, value, Nome),
        send(C, value, Cognome),
        send(S, value, Sesso),
        send(E, value, Età),
        send(Dip, value, Dipartimento),
        send(F, append(D1)),
        send(F, open(position := P)),
        writeln(Nome),
        writeln(Cognome)
    ;
    db_search1(Nome, Cognome, Record)).

db_search1(Nome, Cognome, Record) :-
    (   Record == end_of_file
    ->   write('Spiacenti, '),
         write(Nome),
         put(32),
         write(Cognome),
         put(32),
         writeln('non si trova nel database')
    ;   db_search(Nome, Cognome)).

fine(X) :- free(X).