:- dynamic(person/5).
:- dynamic(animal/1).
:- dynamic(in_cage/1).

setup :-
    seeing(S),
    see('people.txt'),
    read_data,
    write('Data read'),
    nl,
    seen,
    see(S).
read_data :-
    read(A),
    process(A).
process(end_of_file).
process(A) :-
    read(B), read(C), read(D), read(E),
    assertz(person(A, B, C, D, E)),
    read_data.

remove(Forename, Surname) :-
    retract(person(Forename, Surname, _, _, _)).

change(Forename, Surname, New_Job) :-
    person(Forename, Surname, Age, City, Job),
    retract(person(Forename, Surname, Age, City, Job)),
    assertz(person(Forename, Surname, Age, City, New_Job)).

output_data :-
    telling(T),
    tell('people_update.txt'),
    write_data,
    told,
    tell(T),
    write('Data written'),
    nl.
write_data :-
    person(A, B , C, D, E),
    write(A), write('. '),
    write(B), write('. '),
    write(C), write('. '),
    write(D), write('. '),
    write(E), write('.'), nl,
    fail.
write_data.

add_data :-
    repeat,
    write('Please, enter new data: '),
    nl,
    read(UserInput),
    assertz(animal(UserInput)),
    UserInput == end,
    retract(animal(end)).

display_animals :-
    animal(X),
    write(X),
    nl,
    fail.
display_animals.

zoo :-
    animal(X),
    assertz(in_cage(X)),
    fail.
zoo.
