# Inferenza MPE e MAP nelle reti bayesiane
Il progetto è diviso in 5 file:
* Inference
* MPEAssignment
* FinalAssignment     
* InputWindow
* MapTest

## Inference
Questa classe contiene tre tipi di inferenza esatta: MPE, MAP e Variable Elimination.
Variable Elimination è stata utilizzata per calcolare la distribuzione congiunta delle variabili di evidenza, la quale corrisponde alla costante di normalizzazione quando viene fatta l'inferenza MPE e MAP.

## MPEAssignment
Questa classe contiene una lista di assegnamenti per le variabili aleatorie.

## FinalAssignment
Questa classe viene utilizzata per salvare gli assegnamenti che massimizzano la probabilità e permette una volta completata l'inferenza di calcolare l'assegnamento finale delle variabili di interesse.
Per salvare gli assegnamenti è stata utilizzata una HashMap, ogni volta che durante l'inferenza, viene trovata un assegnamento con probabilità più alta viene aggiunto alla HashMap.

## InputWindow
È l'interfaccia grafica, è stata utile per rendere più agevole i test sulle reti bayesiane.

## MapTest
MAP e Variable Elimination fanno sumout delle variabili aleatorie, sul libro viene menzionata un'ottimizzazione per l'inferenza Variable Elimination.
Viene fatto notare che se una variabile non è antenata di una variabile di query o di evidenza, allora è irrilevante per il calcolo dell'inferenza.
In questo progetto è stata implementata questa ottimizzazione ed è stata applicata all’inferenza MAP.

Questa classe è stata creata per verificare se l’ottimizzazione è valida e da un risultato corretto anche con l’inferenza MAP.
L’unica rete sulla quale è stato applicato questo test è hepar2, in quanto è abbastanza grande e l’inferenza MPE era applicabile senza che si bloccasse, per colpa della RAM o di un ordinamento delle variabili svantaggioso.
Purtroppo però è una di quelle reti che hanno il file .bif diverso dal .net.

Quindi come test, siccome non era possibile confrontare i risultati con SamIam, abbiamo pensato di compiere un’inferenza MAP con l’ottimizzazione e un’inferenza senza e confrontare i risultati.
Il test è stato effettuato con:
* 10 variabili di evidenza prese casualmente.
* variabili di MAP prese casualmente, aumentate di numero fino ad arrivare al numero massimo ottenendo quindi un’inferenza MPE.

Gli assegnamenti delle variabili MAP per ogni test sono stati identici e la probabilità in alcuni casi era uguale in altri è variata nell’ordine di 10-20, siccome questa variazione è molto piccola, probabilmente è dovuta a un’imprecisione delle variabili double, che hanno una precisione di 15 cifre decimali.
Nella maggior parte dei casi l’ottimizzazione ha ridotto il tempo di inferenza, in alcuni l’ha anche dimezzato.

In sostanza l’ottimizzazione sembra essere valida, ma non ne siamo certi dato che non si è potuto confrontare il risultato con SamIam.

## Test sulle reti Bayesiane
Per fare i test sulle reti bayesiane del repository fornito, è stato utilizzato il parser dei file .bif di Scaletta.<br>
Alcune reti tra cui Barley, Insurance, Hailfinder, Hepar2 e Sachs hanno i file .net diversi rispetto i file .bif.<br>
Di conseguenza le probabilità calcolate o addirittura gli assegnamenti nelle reti più grandi non corrispondono.<br>
L’inferenza MPE non va su tutte le reti, su quelle più grandi non termina perché i fattori sono troppo grandi oppure perché finisce la memoria RAM.<br>
Con la classe MapTest ho potuto verificare che l’inferenza richiede più tempo man mano che il numero di variabili MAP raggiunge la metà delle variabili disponibili.<br>
Mentre quando le variabili di MAP sono poche o quasi tante quante il totale l’inferenza richiede poco tempo.<br>
L’ottimizzazione ha effetto sui tempi dell’inferenza solo se vengono scelte delle variabili MAP vicino alla radice, queste avranno molti non antenati che verranno eliminati e quindi non calcolati, se invece viene scelta una variabile vicino alle foglie questo farà sì che nel calcolo rimarranno un maggior numero di variabili, rallentando la computazione.<br>
L’aumentare del numero di variabili di evidenza, riduce il tempo di inferenza, però aumenta quello necessario per il calcolo della costante di normalizzazione.

## Reti utilizzate
### Reti piccole < 20 nodi
* Earthquake
* Asia
* Sachs

Earthquake e Asia funzionano perfettamente con entrambe le inferenze e vengono calcolate nell’ordine dei millisecondi.
Sachs ha gli assegnamenti che corrispondono, ma le probabilità diverse.

### Reti medie 20-50 nodi
* Insurance
* Barley

Sia insurance che barley, danno risultati diversi rispetto a samiam

### Reti grandi 50-100 nodi
* Hailfinder
* Hepar2

Per la rete hepar2 va sia MPE che MAP variazione di qualche cifra decimale rispetto SAMIAM,
invece per la rete hailfinder va solo MAP e va quando si scelgono variabili vicino alla radice, diversi assegnamenti e cifre decimali

### Reti molto grandi 100-1000 nodi
* Andes

Va solo MAP e va quando si scelgono variabili vicino alla radice, assegnamenti e cifre decimali identici.
