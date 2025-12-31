# Global Electricity Production Report – Dashboard interattiva in Excel

Questo progetto riguarda l'analisi e la visualizzazione di dati sulla produzione globale di energia elettrica, con focus sui trend di produzione da fonti rinnovabili. Ho costruito una dashboard interattiva che consente di esplorare i dati per paese e per fonte energetica.

Il dataset è scaricabile gratuitamente al seguente link: https://www.kaggle.com/datasets/sazidthe1/global-electricity-production

## Obiettivi del progetto

- Identificare i principali produttori mondiali (top 15 -> 90% della produzione globale), con le relative quote di produzione.
- Creare una dashboard interattiva per:
-   Identificare per ciascun paese le quote di produzione di energia elettrica da fonti rinnovabili in relazione alla produzione di energia elettrica totale.
-   Mostrare per ciascun paese le quote di produzione e i trend di crescita da fonti specifiche.

## Indice

- [Global Electricity Production Report – Dashboard interattiva in Excel](#global-electricity-production-report--dashboard-interattiva-in-excel)
  - [Obiettivi del progetto](#obiettivi-del-progetto)
  - [Indice](#indice)
  - [Riassunto del progetto](#riassunto-del-progetto)
    - [Pulizia dei dati](#pulizia-dei-dati)
    - [Creazione e ordinamento delle liste](#creazione-e-ordinamento-delle-liste)
    - [Studio Top 15](#studio-top-15)
    - [Analisi](#analisi)
    - [Dashboard interattiva](#dashboard-interattiva)

## Riassunto del progetto

### Pulizia dei dati
![Pulizia dei dati](01_Data_cleaning.png)

1. Caricamento del .csv con PowerQuery.
2. Filtrazione di tutte le voci non necessarie.
3. Conversione dei valori nei formati corretti.
4. Aggiunta di colonne di supporto per facilitare le operazioni successive di somma condizionale.

<details>
  <summary>Dettagli tecnici:</summary>

Utilizzata la funzione `SORT(UNIQUE())` per la raccolta e l'organizzazione delle voci all'interno del dataset.

</details>

---
### Creazione e ordinamento delle liste
![Creazione liste](02_List.png)

1. Estrapolazione, aggregazione e ordinamento di dati fondamentali quali: paese, anno, tipo di fonte energetica.
2. Discriminazione tra fonti rinnovabili e non rinnovabili.

<details>
  <summary>Dettagli tecnici:</summary>

1. Utilizzo di funzioni `ISNUMBER(MATCH())` per la generazione della colonna di supporto *is_renewable*. Questa colonna di supporto al dataset ci consentirà la discriminazione tra rinnovabili e non rinnovabili.
2. Poichè siamo interessati ad aggregare i valori di energia prodotta anno per anno, estraiamo l'anno dalla colonna *date* con la funzione `YEAR()`

</details>

---

### Studio Top 15
![Studio Top 15](03_Study.png)

Al fine di semplificare l'analisi, sono stati considerati soltanto i primi 15 paesi per produzione di energia elettrica, poichè da soli contribuiscono per il 90% della produzione di energia elettrica totale.

<details>
  <summary>Dettagli tecnici:</summary>

Per verificarlo, è stata calcolata una tabella con le produzioni totali anno per anno di ciascun paese tramite la funzione di seguito riportata:
```
IFERROR(
SUMIFS(
global_electricity_production!$E$2:$E$121070;
global_electricity_production!$A$2:$A$121070;"="&study!$B3;
global_electricity_production!$B$2:$B$121070;"="&study!C$2);
NA())
```
impostando come condizioni il paese e l'anno di produzione.

Da qui in avanti, saranno trascurati i valori dal 2010 al 2014, poichè non disponibili per alcuni paesi della lista.

Sono state poi calcolate le medie di produzione nell'arco temporale selezionato e infine si sono raccolti i primi 15 valori con la funzione:
```
=INDEX(SORT(Q3:Q50;1;-1;FALSE);SEQUENCE(15);1)
```
Una funzione simile è stata usata per raccogliere e riordinare i nomi dei paesi.
</details>

---

### Analisi
![Analisi quote di produzione e tassi di crescita](04_Calculation.png)

In questa pagina si sono svolti i calcoli necessari per raggiungere gli altri due obiettivi del progetto.

Si sono quindi stilate diverse tabelle che riportano le quantità di energia elettrica prodotte per anno e paese, sia da fonti rinnovabili che totali, e si sono in seguito ricavati i valori medi e le crescite di produzione medie dal 2015.

<details>
  <summary>Dettagli tecnici:</summary>

Come per il capitolo precedente, si sono utilizzate delle somme condizionali:
```
=IF(

SUMIFS(

global_electricity_production!$E$2:$E$121070;

global_electricity_production!$A$2:$A$121070;"="&$C4;
global_electricity_production!$B$2:$B$121070;"="&I$3;
global_electricity_production!$F$2:$F$121070;"="&is_renewable

)<>0;

SUMIFS(

global_electricity_production!$E$2:$E$121070;

global_electricity_production!$A$2:$A$121070;"="&$C4;
global_electricity_production!$B$2:$B$121070;"="&I$3;
global_electricity_production!$F$2:$F$121070;"="&is_renewable
);

NA())
```
facendo però attenzione alla presenza di dati non disponibili che avrebbero potuto influenzare il calcolo dei valori medi. Impostando `NA()` come valore in caso di somma nulla, è possibile escludere la corrispondente cella dal calcolo della media.

Le funzioni `SORT()` e `SORTBY()` sono state fondamentali per riordinare i risultati e poter visualizzare quindi eventuali grafici o classifiche sulla dashboard.

</details>

---

### Dashboard interattiva
![Dashboard interattiva](05_Dashboard.png)

I dati ottenuti dall'analisi precedente sono stati infine richiamati in una pagina riassuntiva.

La pagina si divide in due sezioni:

- Sezione interattiva a sinistra:
Sono disponibili due menu a tendina, *country* e *source*. Selezionando una specifica combinazione, le tabelle si ricalcolano per fornire dati generali sul paese selezionato e le classifiche in termini di quote e tassi di crescita della fonte energetica selezionata.
- Sezione statica a destra:
In alto sono mostrati i paesi con le produzioni di energia rinnovabile o con i tassi di crescita più alti.
In basso è presente un grafico a barre che mostra la produzione media totale per ciascun paese, utile per mostrare visivamente la quota di energia rinnovabile generata rispetto a quella totale.
