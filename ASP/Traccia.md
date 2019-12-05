Answer Set Programming (ASP). Questa parte di laboratorio riguarda
l’utilizzo del paradigma ASP per lo svolgimento di alcuni esercizi
utilizzando lo strumento CLINGO. Si richiede di formulare e risolvere uno
dei seguenti problemi di soddisfacimento di vincoli:
• generazione del calendario della fase finale della Champions
League di calcio. Il problema è descritto come segue:
• ci sono 32 squadre, provenienti da città di diverse
nazioni europee
• le squadre vengono organizzate in 8 gironi (gruppo A,
gruppo B, …, gruppo H) da 4 squadre ciascuno
• due squadre della stessa nazione non possono essere
collocate nello stesso gruppo
• in ogni gruppo, ciascuna squadra deve affrontare due
volte tutte le altre tre squadre del gruppo, una volta in
casa e una volta in trasferta
• gli incontri vengono raggruppati in “giornate”, durante le
quali tutte le 32 squadre affrontano un’avversaria.
Pertanto, il calendario si comporrà di 6 giornate, tre per
le gare di andate e tre per le gare di ritorno
• due squadre della stessa città non possono giocare
entrambe in casa durante la medesima giornata
• una squadra non può giocare più di due partite
consecutive in casa o più di due partite consecutive in
trasferta
• devono essere presenti almeno 2 coppie di squadre
della stessa città ed almeno quattro nazioni con quattro
squadre ciascuna (è possibile e consigliato fare
riferimento alle squadre che hanno giocato la
competizione per l’edizione 2018/19 e che rispettano i
requisiti richiesti, elencate nel documento
champions1819.pdf a disposizione sulla pagina moodle
del corso).
• generazione del calendario settimanale delle lezioni di una
scuola media che aderisce al progetto “Pellico”: ad ogni
insegnamento è associata un’aula o un laboratorio, e gli
studenti si spostano nell’aula della lezione prevista in stile
campus universitario. In particolare:
• ci sono otto aule: lettere (2 aule), matematica,
tecnologia, musica, inglese, spagnolo, religione;
• ci sono tre laboratori: arte, scienze, educazione fisica
(palestra);
• ci sono due docenti per ciascuno dei seguenti
insegnamenti: lettere, matematica, scienze;
• vi è un unico docente per tutti gli altri insegnamenti;
• ci sono due classi per ogni anno di corso, una a regime
“tempo prolungato” ed una a regime “tempo normale”. Si
assuma che l’unica differenza riguarda la frequenza di
attività extra-scolastiche e la partecipazione alla mensa
scolastica, mentre non vi è alcuna differenza per quanto
riguarda il calendario delle lezioni, di 30 ore
complessive, da distribuire in 5 giorni (da lunedì a
venerdì), 6 ore al giorno. Per convenzione, si assuma
che la sezione A sia tempo prolungato e che la sezione
B sia tempo normale: le classi sono, pertanto: 1A, 1B,
2A, 2B, 3A, 3B;
• ogni docente insegna una ed una sola materia, con
l’eccezione di matematica e scienze, ossia un docente 
incaricato di insegnare matematica risulterà anche
insegnante di scienze (non necessariamente per la
stessa classe);
• per ogni classe, sono previste 10 ore di lettere, 4 di
matematica, 2 di scienze, 3 di inglese, 2 di spagnolo, 2
di musica, 2 di tecnologia, 2 di arte, 2 di educazione
fisica, 1 di religione.
