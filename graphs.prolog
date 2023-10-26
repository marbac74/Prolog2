% Grammar Rules

s(s(NP1, VP)) --> np1(NP1) , vp(VP).
s(s(NP1, AdvP)) --> np1(NP1), advp(AdvP).

np1(np1(DET, N)) --> det1(DET), n1(N).
np1(np1(DET, ADJP)) --> det1(DET), adjp1(ADJP).
np2(np2(DET, N)) --> det2(DET), n2(N).
np2(np2(DET, ADJP)) --> det2(DET), adjp2(ADJP).

adjp1(adjp1(Adj1, N1)) --> adj1(Adj1), n1(N1).
adjp2(adjp2(Adj2, N2)) --> adj2(Adj2), n2(N2).

vp(vp(V, NP2)) --> v(V), np2(NP2).
vp(vp(V)) --> v(V).

advp(advp(AdvP, VP)) --> adv(AdvP), vp(VP).
advp(advp(VP, AdvP)) --> vp(VP), adv(AdvP).

% Lexicon

v(v(X)) --> [X], {member(X, [sleeps, eats, walks, feeds, lives, beats, reads])}.

det1(det1(X)) --> [X], {atom_codes(X, Codes), 
                        atom_codes(a, A),
                        atom_codes(an, An),
                        atom_codes(the, The),
                        (prefix(A, Codes); prefix(An, Codes); prefix(The, Codes))
                        }.
det2(det2(X)) --> [X], {atom_codes(X, Codes),
                        atom_codes(a, A),
                        atom_codes(an, An),
                        atom_codes(the, The),
                        (prefix(A, Codes); prefix(An, Codes); prefix(The, Codes))
                        }.

n1(n1(X)) --> [X], {member(X, [cat, man, boy, girl, dog, book, cake])}.
n2(n2(X)) --> [X], {member(X, [cat, man, boy, girl, dog, book, cake])}.

adj1(adj1(X)) --> [X], {atom_codes(X, Codes),
                        atom_codes(old, Old),
                        atom_codes(interesting, Interesting),
                        atom_codes(tasty, Tasty),
                        atom_codes(curious, Curious),
                        atom_codes(blonde, Blonde),
                        atom_codes(stray, Stray),
                        (prefix(Old, Codes); prefix(Interesting, Codes); prefix(Tasty, Codes);
                        prefix(Curious, Codes); prefix(Blonde, Codes); prefix(Stray, Codes))
                        }.
adj2(adj2(X)) --> [X], {atom_codes(X, Codes),
                        atom_codes(old, Old),
                        atom_codes(interesting, Interesting),
                        atom_codes(tasty, Tasty),
                        atom_codes(curious, Curious),
                        atom_codes(blonde, Blonde),
                        atom_codes(stray, Stray),
                        (prefix(Old, Codes); prefix(Interesting, Codes); prefix(Tasty, Codes);
                        prefix(Curious, Codes); prefix(Blonde, Codes); prefix(Stray, Codes))
                        }.

adv(adv(X)) --> [X], {member(X, [abroad, alone, eagerly, regularly, silently, slowly])}.

% Processing Input and writing the relative .gv file

start(Sentence, File) :-
    tell(File),
    writeln('strict graph {'),
    writeln('node [shape=plaintext]'),
    told,
    lex_unique(Sentence, NewSentence, []),
    s(Parse, NewSentence, []),
    process(Parse, File),
    append(File),
    writeln('}'),
    !,
    told.

process(Parse, File) :-
    Parse =.. List,
    length(List, N),
    (   N =:= 3
    ->  draw_graph2(List, File)
    ;   draw_graph1(List, File)
    ).

draw_graph1([Label, Item|_], File) :-
    (   atom(Item)
    ->  append(File),
        write(Label),
        put(32),
        write('--'),
        put(32),
        writeln(Item),
        (   indexed(Item)
        ->  remove_index(Item, NewItem),
            swritef(String, '%w [label=\"%w\"]', [Item, NewItem]),
            writeln(String)
        ; true
        ),
        told
    ;   append(File),
        write(Label),
        put(32),
        write('--'),
        put(32),
        functor(Item, Fun, _),
        writeln(Fun),
        process(Item, File)
    ).

draw_graph2([Label, Branch1, Branch2|_], File) :-
        append(File),
        write(Label),
        put(32),
        write('--'),
        put(32),
        functor(Branch1, Fun1, _),
        functor(Branch2, Fun2, _),
        put(123),
        write(Fun1),
        put(32),
        write(Fun2),
        put(125),
        nl,
        told,
        process(Branch1, File),
        process(Branch2, File).

/*  lex_unique(Input, Output, []) is a Prolog predicate that takes a Wordlist 
    as an input and replaces all lexical items appearing more than once in it (if any)
    in such a way to achieve lexical uniqueness (no terminal nodes holding the same value).
    This predicate is useful in sight of writing a .gv file as output (dot language) 
    in which all nodes must be distinct in order to draw non cyclic binary branching trees */

lex_unique([], [], _).
lex_unique([Item|Rest], [NewItem|Tail] , PreviousItems) :-
    member(Item, PreviousItems),
    random_between(0, 999, Index),
    atom_concat(Item, Index, NewItem),
    lex_unique(Rest, Tail, PreviousItems),
    !.
lex_unique([Item|Rest], [Item|Tail], PreviousItems) :-
    lex_unique(Rest, Tail, [Item|PreviousItems]).

/*  The predicate remove_index(Input, Output) takes as input an atom containing a numeric index at its end
    and outputs an atom stripped of it, this in sight of drawing the labelled syntactic tree of the parsed
    sentence. The predicate noindex/1 is a help predicate to filter numeric chars contained in atoms */

noindex(X) :-
    X > 64.

remove_index(Atom, NewAtom) :-
    atom_codes(Atom, Codes),
    include(noindex, Codes, Filtered),
    atom_codes(NewAtom, Filtered).

indexed(Atom) :-
    atom_codes(Atom, Codes),
    last(Codes, Last),
    (Last < 58, Last > 47).