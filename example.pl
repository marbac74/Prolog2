:- use_module(library(pce)).

show_employee :-
    new(Dialog, dialog('Show employee')),
    send_list(Dialog, append,
              [ new(N1, text_item(first_name)),
                new(N2, text_item(family_name)),
                new(S, menu(sex)),
                new(A, int_item(age, low := 18, high :=  70)),
                new(D, menu(department, cycle)),
                button(cancel, message(Dialog, destroy)),
                button(show, and(message(@prolog,
                                         search_employee,
                                         N1?selection,
                                         N2?selection),
                                 message(Dialog, destroy)))
              ]),
    send_list(S, append, [male, female]),
    send_list(D, append, [research, it_solutions, sales, marketing, human_resources]),
    send(Dialog, default_button, enter),
    send(Dialog, open).