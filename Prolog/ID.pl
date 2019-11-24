% Se fallisce la DFS, incremento di 1 la Soglia (COMPLETEZZA)
iterative_deepening_aux(Soglia, MaxIt, Sol):-
    Soglia < MaxIt,
    iniziale(S),
    \+dfs_aux(S,Sol,[S],Soglia),!,
    NuovaSoglia is Soglia + 1,
    iterative_deepening_aux(NuovaSoglia, MaxIt, Sol).

% DFS trova una soluzione (CORRETTEZZA e OTTIMALITA)
iterative_deepening_aux(Soglia, _, Sol):- iniziale(S), dfs_aux(S,Sol,[S],Soglia).

iterative_deepening(Soluzione):-
    num_righe(R),
    num_col(C),
    numeroOccupate(NO),
    MaxIteration is ((R * C) - NO),
    iterative_deepening_aux(0, MaxIteration, Soluzione).

% dfs_aux(S,ListaAzioni,Visitati,Soglia)
dfs_aux(S,[],_,_):-finale(S).
dfs_aux(S,[Azione|AzioniTail],Visitati,Soglia):-
    Soglia>0,
    applicabile(Azione,S),
    trasforma(Azione,S,SNuovo),
    \+member(SNuovo,Visitati),
    NuovaSoglia is Soglia-1,
    dfs_aux(SNuovo,AzioniTail,[SNuovo|Visitati],NuovaSoglia),!.
