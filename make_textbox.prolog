:- use_module(library(pce)).

make_textbox(Ref, Width, Height, String) :-
    new(Ref, device),
    new(@box, box(Width, Height)),
    Textx is (Width / 2) - 15,
    Texty is (Height / 2) - 10,
    new(@text, text(String)),
    send(Ref, display(@box)),
    send(Ref, display(@text, point(Textx, Texty))).