Italiano | [English](/README.md)

# Produzione di energia elettrica globale – Analisi dei dati con Excel Power Pivot

Analisi dell’evoluzione della produzione elettrica globale, con focus sulla **transizione energetica** e sulla **stabilità dei trend di lungo periodo**.

Il progetto è concepito come **portfolio project** e mette al centro:
- data modeling
- coerenza analitica delle KPI
- confrontabilità temporale
- reporting decisionale

## Obiettivo del progetto

L’obiettivo è fornire una vista **sintetica, stabile e comparabile nel tempo** del sistema di produzione elettrica globale, rispondendo a domande chiave quali:

- Come evolve la **produzione elettrica globale** nel lungo periodo?
- Qual è il contributo relativo delle **fonti rinnovabili e non rinnovabili**?
- I trend osservati sono **strutturali o guidati da volatilità annuale**?
- Esistono differenze significative tra paesi in termini di **mix energetico**?
- La crescita della produzione rinnovabile è **proporzionale ai volumi totali** o concentrata in specifiche aree?

L’approccio adottato è **KPI-driven** e orientato al **supporto decisionale**, privilegiando stabilità e interpretabilità rispetto al dettaglio transazionale.

## Dataset

Il dataset di partenza contiene informazioni su:

- paese
- data (utilizzata esclusivamente per l’estrazione dell’anno)
- tipologia di flusso energetico
- fonte energetica
- quantità di energia prodotta (GWh)

Il dataset non è normalizzato e richiede un processo ETL (edit, transform and load) completo prima di poter essere utilizzato in un modello analitico.

## Pulizia e trasformazione dati

Il processo di trasformazione è stato realizzato interamente in **Power Query** e include:

1. importazione del file CSV
2. conversione esplicita dei tipi di dato
3. normalizzazione delle categorie:
   - fonti energetiche
   - flussi energetici
4. estrazione dell’anno dalla data
5. creazione delle tabelle dimensionali
6. costruzione della tabella dei fatti con **chiavi surrogate**
7. rimozione dei campi non analitici

Il risultato è un **modello dati ripetibile e stabile**, ottimizzato per analisi di lungo periodo.

## Modello dati

Il modello utilizza una **struttura a stella**, composta da:

- una **fact table** contenente le quantità energetiche
- tabelle dimensionali per:
  - contesto geografico
  - contesto temporale
  - fonte energetica
  - tipologia di flusso

<p align="center">
  <img src="06_dashboard/star_scheme.png" 
       alt="Schema a stella del modello dati - tabella dei fatti e dimensioni"
       width="650">
</p>
<p align="center">
  <em>Schema a stella del modello dati - tabella dei fatti e dimensioni</em>
</p>

Le relazioni sono:
- one-to-many
- a direzione singola

## KPI e logica analitica

Le KPI principali sono progettate per garantire **coerenza semantica** e confrontabilità:

- produzione elettrica totale
- quota di energia rinnovabile
- trend temporali tramite **media mobile a tre anni**
- confronto tra paesi su basi omogenee

Le metriche privilegiano letture strutturali rispetto a variazioni annuali isolate.

## Dashboard

Dal modello dati viene derivata una **dashboard analitica** sviluppata in Excel con **Power Pivot**.

La dashboard fornisce:
- una vista di overview sugli indicatori energetici principali
- analisi temporali stabili
- confronto tra paesi e fonti

<p align="center">
  <img src="06_dashboard/dashboard_overview.png" 
       alt="Vista complessiva della dashboard"
       width="950">
</p>
<p align="center">
  <em>Vista complessiva della dashboard</em>
</p>

## Scelte metodologiche

- Le KPI core si basano sulla **produzione elettrica totale**, definita come somma di:
  - produzione netta
  - energia esportata
- I flussi diversi da `net_produced` ed `exported` sono esclusi dal core analitico perché rappresentano utilizzi, perdite o scambi di sistema
- Le medie mobili a tre anni sono utilizzate per ridurre la volatilità e rendere leggibili i trend strutturali

Il progetto privilegia **stabilità analitica e interpretabilità** rispetto alla massimizzazione del dettaglio.

## Principali evidenze

- La crescita della produzione elettrica globale è concentrata nei paesi con i maggiori volumi produttivi, con una classifica sostanzialmente stabile nel tempo.
- Nella maggior parte dei paesi analizzati non emerge un trend strutturale di aumento della quota percentuale di rinnovabili.
- L’incremento netto della produzione totale osservato a partire dal 2016–2017 è seguito da una fase di stabilizzazione fino al 2023.
- Le dinamiche precedenti al 2016 risultano meno affidabili a causa della copertura incompleta dei dati.
- La presenza di categorie energetiche aggregate può comportare una sottostima della produzione rinnovabile.
- Le medie mobili a tre anni migliorano la leggibilità delle dinamiche di medio periodo riducendo la volatilità annuale.

## Versione preliminare in Excel tradizionale

Il repository include una versione iniziale sviluppata in **Excel tradizionale**, basata su formule e calcoli manuali.

Questa versione è mantenuta intenzionalmente **senza ulteriori ottimizzazioni** con l’obiettivo di:

- documentare l’evoluzione del progetto
- mostrare le logiche di calcolo in Excel tradizionale
- evidenziare i limiti di scalabilità di un approccio non modellato

La soluzione definitiva è basata su **Power Query e Power Pivot**.

## TStrumenti utilizzati

- **Pulizia e trasformazione dati:** Excel Power Query
- **Modellazione e visualizzazione dati:** Excel Power Pivot + misure DAX
- **IDE:** Visual Studio Code
- **Versionamento e documentazione:** Git / GitHub

## Competenze dimostrate

- data modeling con schema a stella
- progettazione ETL in Power Query
- sviluppo di misure DAX
- analisi energetica
- progettazione di KPI stabili nel tempo
- documentazione tecnica strutturata

## Documentazione tecnica

- [Caricamento e trasformazione dati](03_etl/etl.it.md)
- [Panoramica del modello dati](04_data_model/model_overview.it.md)
- [Misure DAX e logica KPI](05_dax/dax.it.md)
- [Dashboard](06_dashboard/dashboard_overview.it.md)
- [Versione preliminare](/00_legacy_excel_traditional)
- *[Dataset originale](https://www.kaggle.com/datasets/sazidthe1/global-electricity-production)*