:- use_module(library(pce)).

fileviewer(Dir) :-
    new(DirObj, directory(Dir)),
    new(F, frame('File Viewer')),
    send(F, append(new(B, browser))),
    send(new(D, dialog), below(B)),
    send(D, append(button(view, message(@prolog, view, DirObj, B?selection?key)))),
    send(D, append(button(quit, message(F, destroy)))),
    send(B, members(DirObj?files)),
    send(F, open).

view(DirObj, F) :-
    send(new(V, view(F)), open),
    get(DirObj, file(F), FileObj),
    send(V, load(FileObj)).

layoutdemo1 :-
    new(D, dialog('Layout Demo 1')),
    send(D, append, new(BTS, dialog_group(buttons, group))),
    send(BTS, gap, size(30, 30)),
    send(BTS, alignment, center),
    send(BTS, append, button(open)),
    send(BTS, append, button(delete), right),
    send(BTS, append, button(infos), right),
    send(BTS, layout_dialog),
    send(D, append, new(LB, list_browser), below),
    send(D, append, new(TI, text_item(name, '')), below),
    send(LB, alignment, left),
    send(D, layout),
    send(LB, bottom_side, BTS?bottom_side),
    send(LB, right_side, TI?right_side),
    send(D, open).