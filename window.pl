:- use_module(library(pce)).

% Create a new window
window(Window) :-
    new(Window, window('Hello World')),
    send(Window, size, size(400, 200)).

% Add a "Hello World" label to the window
label(Window) :-
    new(Label, label(text, 'Hello World')),
    send(Window, display, Label, point(10, 10)).

% Add an "OK" button to the window
button(Window) :-
    new(Button, button(close)),
    send(Window, display, Button, point(175, 85)),
    send(Button, message, message(Window, destroy)).

% Open the window and start the event loop
main :-
    window(Window),
    label(Window),
    button(Window),
    send(Window, open).