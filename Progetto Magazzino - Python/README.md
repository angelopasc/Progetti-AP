Il programma rappresenta un software di gestione del magazzino di un negozio di prodotti vegani. 
Il software lavora su un file csv che viene generato (se non presente) all'avvio del codice oppure viene aperto in modalità lettura o scrittura, a seconda dell'operazione che deve essere fatta. 
Le operazioni disponibili sono:
- elenco dei prodotti presenti a magazzino;
- aggiunta di un nuovo prodotto in magazzino;
- vendita del prodotto con relativa decurtazione delle quantità;
- stampa dei ricavi lordi e dei profitti delle vendite effettuate
- rimozione di prodotti aggiunti erroneamente a magazzino*
- aiuto, per mostrare l'elenco di tutti i comandi disponibili

E' stato scritto un modulo contenente tutte le funzioni utilizzate. Il file viene aperto solo nel momento in cui viene richiamata una funzione (anche se all'avvio del file viene stampata una stringa che notifica
l'apertura del file, in realtà serve solo come controllo sull'esistenza o meno del file).
Per ogni comando da inserire sono state gestite le eccezioni, in modo che non si possa mettere del testo nei campi numerici positivi. 
Qualora si volesse aggiungere un prodotto già presente in magazzino, la quantità del prodotto viene aggiunta alla quantità già presente.
Non è possibile vendere una quantità maggiore di quella presente a magazzino.
E' stata creata una funzione per la gestione della tabulazione, in modo che la prima colonna, cioè quella più lunga contenente la descrizione, fosse in grado dinamicamente di adattarsi alla lunghezza. 
E' stata inserita la libreria emoji per dare un po' di colore e animazione al tutto, quindi consigliamo di installarla prima dell'avvio. 


Possibili features future:
- Gestione del campo iva sul prodotto
- Calcolo del prezzo netto, prezzo lordo, profitti e ricavi netti e lordi
- Reso della merce venduta e storno delle statistiche
- Piccole analisi di vendita sui prodotti venduti
- Utilizzo dell'operatore su ogni transazione o ultima modifica
