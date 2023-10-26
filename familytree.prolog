?- op(150, xfy, is_parent_of).
?- op(150, xfy, is_grandfather_of).
?- op(150, xfy, is_grandmother_of).

X is_parent_of Y :- parent(X, Y).
X is_grandfather_of Y :- grandfather_of(X, Y).
X is_grandmother_of Y :- grandmother_of(X, Y).

mother(ann, henry).
mother(ann, mary).
mother(jane, mark).
mother(jane, francis).
mother(annette, jonathan).
mother(mary, bill).
mother(janice, louise).
mother(lucy, janet).
mother(louise, caroline).
mother(caroline, david).
mother(caroline, janet).
father(henry, jonathan).
father(john, mary).
father(francis, william).
father(francis, louise).
father(john, mark).
father(gavin, lucy).
father(john, francis).
parent(victoria, george).
parent(victoria, edward).
parent(X, Y) :- mother(X, Y).
parent(X, Y) :- father(X, Y).
parent(elizabeth, charles).
parent(elizabeth, andrew).
ancestor(X, Y) :- parent(X, Y).
ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y). 
child_of(A, B) :- mother(B, A).
child_of(A, B) :- father(B, A).
grandfather_of(A, B) :- mother(M, B), father(A, M).
grandfather_of(A, B) :- father(F, B), father(A, F).
grandmother_of(A, B) :- mother(M, B), mother(A, M).
grandmother_of(A, B) :- father(F, B), mother(A, F).