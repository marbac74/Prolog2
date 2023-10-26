:- dynamic(libro/3).
:- dynamic(prestito/3).

trim_whitespace(Input, Output) :-
    atom_string(InputAtom, Input),
    string_codes(InputAtom, InputCodes),
    phrase(trimmed_string(OutputCodes), InputCodes),
    string_codes(OutputAtom, OutputCodes),
    atom_string(Output, OutputAtom).

trimmed_string([]) --> [].
trimmed_string([H|T]) --> whitespace, [H], trimmed_string(T).

whitespace --> [C], { code_type(C, space) }, !, whitespace.
whitespace --> [].

% Definizioni dei fatti
libro('Il Signore degli Anelli', 'J.R.R. Tolkien', 5).
libro('1984', 'George Orwell', 3).
libro('La strada', 'Cormac McCarthy', 2).

% Predicati per la ricerca dei libri per titolo o autore
cercaLibriPerTitolo(Titolo, Libri) :-
    findall((Titolo, Autore, CopieDisponibili), 
            libro(Titolo, Autore, CopieDisponibili), Libri),
    Libri \= [].

cercaLibriPerAutore(Autore, Libri) :-
    trim_whitespace(Autore, AutoreTrimmed),
    downcase_atom(AutoreTrimmed, AutoreMinuscolo),
    debug(cerca_libri, 'Autore inserito: ~w', [AutoreMinuscolo]),
    findall((Titolo, AutoreDB, CopieDisponibili), (
        libro(Titolo, AutoreDB, CopieDisponibili),
        trim_whitespace(AutoreDB, AutoreDBTrimmed),
        downcase_atom(AutoreDBTrimmed, AutoreDBMinuscolo),
        sub_string(AutoreDBMinuscolo, _, _, _, AutoreMinuscolo)
    ), Libri),
    debug(cerca_libri, 'Libri trovati: ~w', [Libri]).

% Predicati per prendere in prestito un libro o restituire un libro
prendiInPrestito(Utente, Titolo, Autore) :-
    libro(Titolo, Autore, CopieDisponibili),
    CopieDisponibili > 0,
    retract(libro(Titolo, Autore, CopieDisponibili)),
    NuoveCopieDisponibili is CopieDisponibili - 1,
    assertz(libro(Titolo, Autore, NuoveCopieDisponibili)),
    (prestito(Utente, Titolo, VecchieCopiePrese) ->
        NuoveCopiePrese is VecchieCopiePrese + 1,
        retract(prestito(Utente, Titolo, VecchieCopiePrese)),
        assertz(prestito(Utente, Titolo, NuoveCopiePrese))
    ; assertz(prestito(Utente, Titolo, 1))).

restituisciLibro(Utente, Titolo, Autore) :-
    retract(prestito(Utente, Titolo, CopiePrese)),
    (
        CopiePrese > 1 ->
        NuoveCopiePrese is CopiePrese - 1,
        assertz(prestito(Utente, Titolo, NuoveCopiePrese))
    ;
        true
    ),
    libro(Titolo, Autore, CopieDisponibili),
    NuoveCopieDisponibili is CopieDisponibili + 1,
    retract(libro(Titolo, Autore, CopieDisponibili)),
    assertz(libro(Titolo, Autore, NuoveCopieDisponibili)).

% Predicato per controllare i prestiti di un utente
controllaPrestiti(Utente, Prestiti) :-
    findall((Titolo, Autore, CopiePrese), (
        prestito(Utente, Titolo, CopiePrese),
        libro(Titolo, Autore, _)
    ), Prestiti),
    Prestiti \= [].

% Predicato per l'interazione con l'utente
interazioneUtente :-
    write('Ciao! Inserisci il tuo nome utente: '),
    flush_output,
    read_line_to_string(user_input, Utente),
    menu(Utente).

menu(Utente) :-
    nl, write('Benvenuto, '), write(Utente), write('. Cosa desideri fare?'), nl,
    write('1. Cerca libri per titolo'), nl,
    write('2. Cerca libri per autore'), nl,
    write('3. Prendi in prestito un libro'), nl,
    write('4. Restituisci un libro'), nl,
    write('5. Controlla i prestiti'), nl,
    write('0. Esci'), nl,
    read_line_to_codes(user_input, SceltaCodes),
    atom_codes(SceltaAtom, SceltaCodes),
    atom_number(SceltaAtom, Scelta),
    eseguiScelta(Utente, Scelta).

eseguiScelta(Utente, 1) :-
    write('Inserisci il titolo del libro: '),
    flush_output,
    read_line_to_string(user_input, Titolo),
    atom_string(TitoloAtom, Titolo),
    cercaLibriPerTitolo(TitoloAtom, Libri),
    (Libri == [] ->
        write('Nessun libro trovato con questo titolo.'), nl
    ;
        stampaLibri(Libri)
    ),
    menu(Utente), !.

eseguiScelta(Utente, 2) :-
    write('Inserisci l\'autore del libro: '),
    flush_output,
    read_line_to_string(user_input, Autore),
    trim_whitespace(Autore, AutoreTrimmed),
    cercaLibriPerAutore(AutoreTrimmed, Libri),
    (Libri == [] ->
        write('Nessun libro trovato per questo autore.'), nl
    ;
        stampaLibri(Libri)
    ),
    menu(Utente), !.

eseguiScelta(Utente, 3) :-
    write('Inserisci il titolo del libro da prendere in prestito: '),
    flush_output(current_output),
    read_line_to_string(user_input, Titolo),
    atom_string(TitoloAtom, Titolo),
    write('Inserisci l\'autore del libro da prendere in prestito: '),
    flush_output(current_output),
    read_line_to_string(user_input, Autore),
    atom_string(AutoreAtom, Autore),
    prendiInPrestito(Utente, TitoloAtom, AutoreAtom),
    write('Libro preso in prestito con successo.'), nl,
    menu(Utente).

eseguiScelta(Utente, 4) :-
    write('Inserisci il titolo del libro da restituire: '),
    flush_output(current_output),
    read_line_to_string(user_input, Titolo),
    atom_string(TitoloAtom, Titolo),
    write('Inserisci l\'autore del libro da restituire: '),
    flush_output(current_output),
    read_line_to_string(user_input, Autore),
    atom_string(AutoreAtom, Autore),
    restituisciLibro(Utente, TitoloAtom, AutoreAtom),
    write('Libro restituito con successo.'), nl,
    menu(Utente).

eseguiScelta(Utente, 5) :-
    (controllaPrestiti(Utente, Prestiti) ->
        stampaPrestiti(Prestiti)
    ;
        write('Non hai alcun libro in prestito al momento.'), nl
    ),
    menu(Utente),
    !.

eseguiScelta(_, 0) :-
    write('Grazie per aver utilizzato il nostro servizio. Arrivederci!').

eseguiScelta(Utente, _) :-
    write('Scelta non valida. Riprova.'), nl,
    menu(Utente).

% Funzione stampaLibri
stampaLibri(Libri) :-
    (Libri == [] ->
        true
    ;
        stampaLibriDettagli(Libri)
    ).

stampaLibriDettagli([]).
stampaLibriDettagli([(Titolo, Autore, CopieDisponibili)|T]) :-
    write('Titolo: '), write(Titolo), nl,
    write('Autore: '), write(Autore), nl,
    write('Copie disponibili: '), write(CopieDisponibili), nl,
    stampaLibriDettagli(T).

stampaPrestiti(Prestiti) :-
    calcolaTotalePrestiti(Prestiti, 0, TotalePrestiti),
    write('Hai '), write(TotalePrestiti), write(' libro/i in prestito:'), nl,
    stampaPrestitiDettagli(Prestiti).

calcolaTotalePrestiti([], Totale, Totale).
calcolaTotalePrestiti([(_, _, CopiePrese)|T], Accumulatore, Totale) :-
    NuovoAccumulatore is Accumulatore + CopiePrese,
    calcolaTotalePrestiti(T, NuovoAccumulatore, Totale).

stampaPrestitiDettagli([(Titolo, Autore, CopiePrese)|T]) :-
    write('Titolo: '), write(Titolo), nl,
    write('Autore: '), write(Autore), nl,
    write('Copie prese in prestito: '), write(CopiePrese), nl,
    nl,
    stampaPrestitiDettagli(T).

:- initialization(interazioneUtente).