% Animals Database

animal(mammal, tiger, carnivore, stripes).
animal(mammal, hyena, carnivore, ugly).
animal(mammal, lion, carnivore, mane).
animal(mammal, zebra, herbivore, stripes).
animal(bird, eagle, carnivore, large).
animal(bird, sparrow, scavenger, small).
animal(reptile, snake, carnivore, long).
animal(reptile, lizard, scavenger, small).

person(john, smith, 45, london, doctor).
person(martin, williams, 33, birmingham, teacher).
person(henry, smith, 26, manchester, plumber).
person(jane, wilson, 62, london, teacher).
person(mary, smith, 29, glasgow, surveyor).

allmammals :- animal(mammal, X, _, _),
              write(X),
              write(' is a mammal'), nl,
              fail.
allmammals.

all(X) :- animal(_, Name, X, _),
          write(Name),
          write(' is a '),
          write(X), nl,
          fail.
all(_).

alltil  :-
        animal(T, X, F, C),
        write(animal(T, X, F, C)),
        nl,
        X=sparrow,
        !.

professions(X) :-
    person(_, _, Age, _, Work),
    Age > X,
    write(Work),
    nl,
    fail.
professions(_).