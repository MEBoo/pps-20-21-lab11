% ex 1
% dropAny(?Elem,?List,?OutList)
dropAny(X,[X|T],T).
dropAny(X,[H|Xs],[H|L]):-dropAny(X,Xs,L).

dropFirst(X,[X|T],T):-!.
dropFirst(X,[H|Xs],[H|L]):-dropFirst(X,Xs,L).

dropLast(X,[H|Xs],[H|L]):-dropLast(X,Xs,L),!.
dropLast(X,[X|T],T).

dropAll(X,L,LD):-copy_term(X,Y),dropFirst(X,L,L2),dropAll(Y,L2,LD),!.
dropAll(X,L,LD):-not(dropFirst(X,L,L2)),LD=L.

% ex 2
% fromList(+List,-Graph)
fromList([_],[]).
fromList([H1,H2|T],[e(H1,H2)|L]):- fromList([H2|T],L).

fromCircList([H1|T],L):- append([H1|T],[H1],LC),fromList(LC,L).

dropNode(G,N,O):- dropAll(e(N,_),G,G2), dropAll(e(_,N),G2,O).

reaching(G,N,O):- findall(Y,member(e(N,Y),G),O).

anypath(G,N1,N2,[e(N1,N3)|P]):- member(e(N1,N3),G),anypath(G,N3,N2,P).
anypath(G,N1,N2,[e(N1,N2)]):- member(e(N1,N2),G),!.

allreaching(G,N,L):- findall(N2,anypath(G,N,N2,_),L).

% 2.7
node(c(X,Y)):- member(X,[0,1,2]),member(Y,[0,1,2]).
link(c(X,Y),c(X,YY)):- node(c(X,Y)), (YY is Y-1; YY is Y+1), node(c(X,YY)).
link(c(X,Y),c(XX,Y)):- node(c(X,Y)), (XX is X-1; XX is X+1), node(c(XX,Y)).
gridToGraph(G):- findall(e(c(X,Y),c(XX,YY)),link(c(X,Y),c(XX,YY)),G).

anypathHops(G,N1,N2,H,[e(N1,N3)|P]):-HH is H-1,HH>0,member(e(N1,N3),G),anypathHops(G,N3,N2,HH,P).
anypathHops(G,N1,N2,H,[e(N1,N2)]):- member(e(N1,N2),G),!.

% ex 3
cell(X,Y,n):- member(X,[0,1,2]),member(Y,[0,1,2]).
generateTable(T):- findall(cell(X,Y,n),cell(X,Y,n),T).
next(T,P,R,NT):-play(T,P,NT),result(NT,P,R).
play([cell(X,Y,n)|T],P,[cell(X,Y,P)|T]).
play([H|T],P,[H|OUT]):- play(T,P,OUT).

game(T,P,R,[T|TL]):- next(T,P,nothing,NT),(P==x,P2=o;P==o,P2=x),game(NT,P2,R,TL).
game(T,P,R,[T,NT]):- next(T,P,R,NT), R\=nothing. 

result([cell(X,Y,n)|T],_,nothing):- !.
result([_|T],_,nothing):- result(T,_,nothing),!.
result(T,P,win(P)):- member(Y,[0,1,2]),won(T,P,0,Y),won(T,P,1,Y),won(T,P,2,Y),!.
result(T,P,win(P)):- member(X,[0,1,2]),won(T,P,X,0),won(T,P,X,1),won(T,P,X,2),!.
result(T,P,win(P)):- won(T,P,0,0),won(T,P,1,1),won(T,P,2,2),!.
result(T,P,win(P)):- won(T,P,0,2),won(T,P,1,1),won(T,P,2,0),!.
won([cell(X,Y,P)|_],P,X,Y):- !.
won([_|T],P,X,Y):- won(T,P,X,Y).
result(_,_,even).

%generateTable(T),game(T,x,win(o),L)