sentence([s1, both, V, NP1, Noun1, NP2, Noun2]) --> 
    noun_phrase(NP1, _, Noun1), verb(both, V), noun_phrase(NP2, _, Noun2), 
    {assertz(wordlist(verb, both, V))}.
sentence([s2, Number, V, NP1, Noun1, NP2, Noun2]) --> 
    noun_phrase(NP1, Number, Noun1), verb(Number, V), noun_phrase(NP2, _, Noun2), 
    {assertz(wordlist(verb, Number, V))}.
sentence([s3, both, V, NP1, Noun1]) --> 
    noun_phrase(NP1, _, Noun1), verb(both, V), adverb,
    {assertz(wordlist(verb, both, V))}.
sentence([s4, Number, V, NP1, Noun1]) --> 
    noun_phrase(NP1, Number, Noun1), verb(Number, V), adverb,
    {assertz(wordlist(verb, Number, V))}.
    

noun_phrase(np1, Number, N) --> determiner, adjective_sequence, noun(Number, N).
noun_phrase(np2, Number, N) --> determiner, noun(Number, N).
noun_phrase(np3, Number, N) --> noun(Number, N).

adjective_sequence --> adjective, adjective_sequence.
adjective_sequence --> adjective.

verb(singular, X) --> [X], {member(X, [hears, sees])}.
verb(plural, X) --> [X], {member(X, [hear, see])}.
verb(both, X) --> [X], {member(X, [sat, saw, took, will_see])}.

determiner --> [X], {member(X, [the, a, an])}.

noun(singular, X) --> [X], {member(X, [cat, mat, man, boy, dog])}.
noun(plural, X) --> [X], {member(X, [cats, mats, men, boys, dogs])}.

adjective --> [X], {member(X, [large, small, brown, orange, green, blue])}.

adverb --> [X], {member(X, [well, badly, quickly, slowly])}.
adverb --> [].

process(File) :- 
    see(File), 
    repeat, 
    read(S), 
    proc(S), 
    S = end_of_file, 
    !, 
    seen.

proc(end_of_file).
proc(S) :- 
    write('Sentence: '), 
    write(S), 
    nl, 
    proc2(S).

proc2(S) :- 
    phrase(sentence(L1), S), 
    write('Structure: '), 
    write(L1), 
    nl, nl, 
    !.
proc2(_) :- 
    write('Invalid sentence structure'), 
    nl, nl, 
    !.