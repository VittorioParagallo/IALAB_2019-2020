% fScore
f(G, pos(R, C), FScore):-
    h(pos(R, C), H),
    FScore is G + H.

% Algoritmo non ha ancora trovato la soluzione
iterative_deepening_astar_aux(Soglia, Sol):-
    iniziale(S),
    f(0, S, F),
    findall(X,dfs_aux(nodo(F,0,S),Sol,[S],Soglia,X),Fexceeded),
    \+member(-1,Fexceeded),!,
    list_min(Fexceeded, NuovaSoglia),
    iterative_deepening_astar_aux(NuovaSoglia, Sol).

% Algoritmo ha trovato la soluzione
iterative_deepening_astar_aux(Soglia, Sol):-
    iniziale(S),
    f(0, S, F),
    dfs_aux(nodo(F,0,S),Sol,[S],Soglia,-1),!.

iterative_deepening_astar(Soluzione):-
    iniziale(S),
    f(0, S, F),
    iterative_deepening_astar_aux(F, Soluzione).

% dfs_aux(nodo(F,G,S),ListaAzioni,Visitati,Soglia,NuovaSoglia)
% Ricerca non eccede la Soglia
dfs_aux(nodo(_,_,S),[],_,_,-1):-finale(S),!.
dfs_aux(nodo(F,G,S),[Azione|AzioniTail],Visitati,Soglia,NuovaSoglia):-
    F =< Soglia,!,
    applicabile(Azione,S),
    trasforma(Azione,S,SNuovo),
	\+member(SNuovo,Visitati),
    g(G, NewG),
    f(NewG, SNuovo, FNew),
    dfs_aux(nodo(FNew, NewG, SNuovo),AzioniTail,[SNuovo|Visitati],Soglia,NuovaSoglia).

% Ricerca eccede la Soglia
dfs_aux(nodo(F,_,_),[],_,_,F).
