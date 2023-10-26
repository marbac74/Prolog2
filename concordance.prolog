% concordance(+Pattern, +List, +Span, -Line)
% finds Pattern in List and displays the Line
% where it appears within Span characters surrounding it.

concordance(Pattern, List, Span, Line) :-
    name(Pattern, LPattern),
    prepend(LPattern, Span, LeftPattern),
    append(_, Rest, List),
    append(LeftPattern, End, Rest),
    prefix(End, Span, Suffix),
    append(LeftPattern, Suffix, LLine),
    name(Line, LLine).

% prefi(+List, +Span, -Prefix) extracst the prefix of List up to
% Span characters. The second rule checks the case in which there
% are less than Span characters in List.

prefix(List, Span, Prefix) :-
    append(Prefix, _, List),
    length(Prefix, Span),
    !.
prefix(Prefix, Span, Prefix) :-
    length(Prefix, L),
    L < Span.

% prepend(+List, +Span, -Prefix) adds Span variables to the
% beginning of List.

prepend(Pattern, Span, List) :-
    prepend(Pattern, Span, Pattern, List).

prepend(_, 0, List, List) :-
    !.
prepend(Pattern, Span, List, Flist) :-
    Span1 is Span - 1,
    prepend(Pattern, Span1, [_|List], Flist).

% Predicate read_file(+FileName, -CodeList) opens a file for reading
% and transforms it to a list of character ASCII codes

read_file(File, List) :-
    see(File),
    read_list(List),
    seen.

read_list([C|L]) :-
    get0(C),
    C =\= -1,
    !,
    read_list(L).
read_list([]).