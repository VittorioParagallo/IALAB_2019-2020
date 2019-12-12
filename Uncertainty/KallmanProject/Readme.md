# Filtro di Kalman

## Modello
Nel nostro progetto il filtro di kalman è stato applicato alla simulazione di un veicolo, che si muove con un moto uniformemente accelerato.
Per l’implementazione del Kalman Filter abbiamo utilizzato la libreria Commons Math di Apache.

Lo stato del processo è modellato con un vettore colonna che indica la posizione e la velocità correnti.
E la matrice di covarianza di errore P che indica la correlazione tra le variabili posizione e velocità.<br>
<img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/Uncertainty/KallmanProject/img/formula.png"/><br><br>
I parametri che vengono utilizzati nella simulazione sono:
* A: è la matrice di trasformazione, modella come la velocità modifica lo stato.
* B: è la matrice di controllo, modella le influenze esterne che possiamo prevedere nel nostro caso come l’accelerazione modifica lo stato.
* u: è il vettore di controllo, contiene solo un parametro l’accelerazione.
* H: è la matrice di osservazione, simula le letture dei sensori.
* R: è il rumore di osservazione, modella l’incertezza delle misure.
* Q: è il rumore del processo, modella le influenze esterne che non possiamo prevedere ad esempio una ruota che slitta.

## La simulazione
Ogni simulazione effettua 60 step, partendo da 0.
Il tempo e la velocità incrementano di 0.1 a ogni step.

Ogni ciclo effettua due operazioni:
<br><img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/Uncertainty/KallmanProject/img/formula1.png"/>
1. la predizione: viene stimato lo stato successivo basandosi sulle informazioni dello stato precedente e le influenze esterne.
1. la correzione:
   1. Viene effettuata una simulazione della misurazione.<br>Le misurazioni vengono simulate con questa formula:<br>z=H\*X+noise<br>dove X è il vettore che rappresenta lo stato reale.
   1. Le informazioni ottenute vengono aggiunte alla stima effettuata dalla predizione per ottenere una stima migliore.

La formula finale che aggiorna lo stato e la covarianza, tenendo conto sia dello stato precedente che la misurazione è la seguente:<br>
<img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/Uncertainty/KallmanProject/img/formula2.png"/><br>
dove K è il Kalman Gain che si calcola così:<br>
<img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/Uncertainty/KallmanProject/img/formula3.png"/><br>

L'immagine seguente riassume tutti i passaggi della simulazione:<br>
<img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/Uncertainty/KallmanProject/img/kalflow.png"/><br>

## Esecuzione
Per utilizzare il programma bisogna lanciare il comando java -jar .\KallmanProject.jar.<br>
È possibile impostare dei parametri per l’esecuzione, si possono inserire al massimo 3 parametri i primi due impostano il rumore per l’esperimento, mentre il terzo modifica la distribuzione iniziale.<br>
I primi due parametri prendono come argomento i seguenti valori “low”, “mid” e “high”.<br>
Il primo parametro è il rumore di osservazione, il secondo invece di processo.<br>
Il terzo parametro se omesso non modifica la distribuzione, altrimenti scrivendo rand viene modificata la distribuzione iniziale.<br>
I parametri vanno messi in ordine, di default il rumore è mid per entrambi i rumori e la distribuzione iniziale parte da 0 0.<br>

Esempio comando:
java -jar .\KallmanProject.jar high low rand

## Esperimenti Rumore
I parametri del rumore impostano 3 livelli di rumore predefiniti.
Per il rumore dell’osservazione viene modificata la variabile measurementNoise, che modifica la matrice R e cambia il comportamento durante la simulazione della misurazione.
MeasurementNoise può assumere i seguenti valori: 0,00001, 10, 100.
<br>Invece per il rumore del processo viene modificata la matrice Q che può assumere i seguenti valori.
```
1)         2)           3)
0 0        10  0        100   0
0 0        0  10        0   100
```
Abbiamo fatto gli esperimenti impostando varie combinazioni di rumore, il primo parametro è il rumore di misurazione il secondo il rumore di processo.<br>
Alcuni grafici sono in prospettiva perchè avendo le linee quasi sovrapposte non si capiva che il filtro si stava comportando bene.<br>
I grafici sono divisi in triplette:
1. La relazione tra lo spazio percorso e la velocità, stimate e reali.
1. l'errore delle stime
1. il kalman gain
### Rumore low low
Le predizioni sono corrette, l’errore per entrambe le variabili è nell’ordine di 10-2, il kalman gain parte da 0.5 e scende subito vicino a 0 il che significa che ci si fida di più della predizione che della misurazione.
<img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/Uncertainty/KallmanProject/img/explowlow.jpeg"/><br>
### Rumore high high
L’errore è alto e varia parecchio per entrambe le variabili, il kalman gain rimane intorno a 0.13
<img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/Uncertainty/KallmanProject/img/exphighhigh.jpeg"/><br>
### Rumore low high
Il kalman gain resta intorno a 0,5 il che indica che dobbiamo fidarci di più delle misurazioni.<br>
L'errore della posizione rimane basso, invece quello della velocità si alza un po ma rimane costante.
<img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/Uncertainty/KallmanProject/img/explowhigh.jpeg"/><br>
### Rumore high low
Si può notare che l'errore della posizione (linea verde) è più alto rispetto a quello della velocità (linea blu), questo è dovuto al fatto che la posizione varia quadraticamente.<br>
Il kalman gain è vicino allo 0 quindi ci si fida di più delle predizioni, il rumore sulle misurazioni ha più effetto del rumore sul processo.
<img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/Uncertainty/KallmanProject/img/exphighlow.jpeg"/><br>
## Variare la distribuzione iniziale dello stato
Utilizzando il parametro rand, la posizione e la velocità iniziale per il filtro vengono randomizzate tra 0 e 10.
### Rumore low low
Il filtro riesce a correggere le stime, si può anche notare che il kalman gain si abbassa gradualmente da 0.5 a 0, indicando che inizialmente corregge la stima utilizzando le misurazioni.
<img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/Uncertainty/KallmanProject/img/explowlowrand.jpeg"/><br>
### Rumore low high
Il filtro riesce a correggere le stime, il kalman gain rimane intorno a 0.5 perchè deve affidarsi alle misurazioni.
<img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/Uncertainty/KallmanProject/img/explowhighrand.jpeg"/><br>
### Rumore high low
Il filtro non riesce più a correggere le stime, perché non ha più modo di misurare correttamente lo stato corrente del veicolo.
<img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/Uncertainty/KallmanProject/img/exphighlowrand.jpeg"/><br>
### Rumore high high
Come sopra il filtro non riesce più a correggere le stime e l'errore varia parecchio per entrambe le variabili.
<img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/Uncertainty/KallmanProject/img/exphighighrand.jpeg"/><br>

## Processo non lineare
Il nostro progetto modella un processo con una variabile che ha un andamento lineare e una variabile che ha un andamento quadratico.
Modificando l’accelerazione, la posizione ha un andamento quadratico anziché lineare, si può infatti notare che nella maggior parte dei casi quando il rumore è mid o high la posizione ha un errore più alto rispetto alla velocità che ha un andamento lineare.
