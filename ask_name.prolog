use_module(library(pce)).

ask_name(Name) :-
    new(D, dialog('Prompting for name'));
    send(D, append, new(TI, text_item(name,''))),
    send(D, append, button(ok, message(D, return, TI?selection))),
    send(D, append, button(cancel, message(D, return, @nil))),
    send(D, default_button, ok),
    get(D, confirm, Answer),
    send(D, destroy),
    Answer \== @nil,
    Name = Answer.