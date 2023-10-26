:- use_module(library(pce)).

setup_run(File) :-
    assertz(quiz(File)),
    see(File),
    readin,
    seen,
    runquiz,
    !.

readin :-
    read(Title),
    assertz(title(Title)),
    readqs.

readqs :-
    repeat,
    read(Qnumber),
    read(Qtext),
    process(Qnumber, Qtext),
    Qtext = endquestions,
    readranges.

process(0, endquestions) :- !.
process(Qnumber, Qtext) :-
    proc2([], Anslist, -9999, Maxscore),
    assertz(question(Qnumber, Qtext, Anslist, Maxscore)).

proc2(Anscurrent, Anslist, Maxsofar, Maxscore) :-
    read(Ans),
    (   (Ans = end, 
        Anslist = Anscurrent, 
        Maxscore = Maxsofar, 
        !)
    ;   (read(Score),
        append(Anscurrent, [ans(Ans, Score)], Ansnew),
        Maxnew is max(Maxsofar, Score),
        proc2(Ansnew, Anslist, Maxnew, Maxscore))
    ).

readranges :-
    repeat,
    read(First),
    proc(First),
    First = endmarkscheme.

proc(endmarkscheme) :- !.
proc(First):-
    read(Last),
    read(Feedback),
    assertz(range(First, Last, Feedback)).

runquiz :-
    retractall(myscore(_, _)),
    assertz(myscore(0, 0)),
    title(T),
    new(@dialog, dialog('Quiz')),
    new(@intro, text(T)),
    new(@button, button('Avanti', and(message(@dialog, destroy), 
                                    message(@intro, destroy),
                                    message(@button, destroy),
                                    message(@prolog, askq)))),
    send_list(@dialog, append, [@intro, @button]),
    send(@button, show_focus_border(false)),
    send(@button, radius(30)),
    send(@dialog, open(point(100, 100))),
    nl.

askq :-
    ( 
        question(Qnumber, Qtext, Anslist, _)
    -> 
        extract(Anslist, Answers),
        new(D, dialog('Quiz')),
        swritef(String, 'Domanda %w', [Qnumber]),
        new(N, text(String)),
        new(Q, text(Qtext)),
        new(A, menu(risposte, choice)),
        send_list(A, append, Answers),
        new(B1, button('Invio', message(@prolog, request, A?selection))),
        send(B1, show_focus_border(false)),
        send(B1, radius(30)),
        new(B2, button('Avanti', and(message(D, destroy), message(@prolog, askq)))),
        send(B2, radius(30)),
        send_list(D, append, [N, Q, A, B1, B2]),
        send(D, open(point(100, 100))),
        send(A, clear_selection)
    ;
        result
    ).

result :-
    myscore(My, Max),
    quiz(File),
    in_range(My, Feedback),
    swritef(String, 'Hai ottenuto %w punti su %w', [My, Max]),
    new(D, dialog('Quiz')),
    new(S, text(String)),
    new(F, text(Feedback)),
    new(B1, button('Rifai', and(message(D, destroy), 
                               message(@prolog, setup_run, File)))),
    new(B2, button('Esci', message(D, destroy))),
    send(B1, show_focus_border(false)),
    send(B1, radius(30)),
    send(B2, radius(30)),
    send_list(D, append, [S, F, B1, B2]),
    send(D, open(point(100, 100))).

request(Answer) :-
    question(Qnumber, Qtext, Anslist, Maxscore),
    retract(question(Qnumber, Qtext, Anslist, Maxscore)),
    member(ans(Answer, Score), Anslist),
    usescore(Score, Maxscore),
    !.

usescore(Score, Maxscore) :-
    retract(myscore(Old, Oldtotal)),
    New is Old + Score,
    Newtotal is Oldtotal + Maxscore,
    assertz(myscore(New, Newtotal)).

extract([], []).
extract([ans(Answer, _)|T1], [Answer|T2]) :- 
    extract(T1, T2).

in_range(My, Feedback) :- 
    range(Min, Max, Feedback),
    (
        (My >= Min , My =< Max)
    ->  true
    ;   fail
    ).