:- use_module(library(pce)).

start :-
    new(Frame, frame('Demo')),
    new(P, point(200, 200)),
    new(D, dialog),
    send(D, append(text_item(name))),
    send(Frame, append(D)),
    send(Frame, open(position := P)).