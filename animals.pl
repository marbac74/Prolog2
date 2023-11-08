:- op(150, xf, isa_dog).
:- op(150, xf, isa_cat).
:- op(150, xf, is_large).
:- op(150, xf, is_small).
:- op(150, xf, isa_large_dog).
:- op(150, xf, isa_small_animal).
:- op(150, xfy, chases).

fido isa_dog.
rover isa_dog.
tom isa_dog.
fred isa_dog.
mary isa_cat.
jane isa_cat.
harry isa_cat.
henry isa_cat.
bill isa_cat.
steve isa_cat.
fido is_large.
mary is_large.
fred is_large.
henry is_large.
steve is_large.
jim is_large.
mike is_large.
rover is_small.
jane is_small.
tom is_small.
X isa_large_dog :- X isa_dog, X is_large.
X isa_small_animal :- X isa_dog, X is_small.
Z isa_small_animal :- Z isa_cat, Z is_small.
X chases Y :- 
        X isa_large_dog, Y isa_small_animal,
        write(X), write(' chases '), write(Y), nl.