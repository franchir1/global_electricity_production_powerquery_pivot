# Dashboard Overview

Questa dashboard sintetizza i principali indicatori relativi alla **produzione di energia elettrica globale**, basandosi sul modello dati sviluppato in Power Query e Power Pivot.

## Obiettivo della dashboard

L’obiettivo principale è **analizzare l’evoluzione della produzione elettrica globale**, con particolare attenzione a:

- dimensione complessiva del sistema energetico  
- transizione energetica (rinnovabili vs non rinnovabili)  
- stabilità dei trend nel lungo periodo  
- contributo reale dei singoli paesi alla crescita globale 

La dashboard adotta un approccio **production-first** e utilizza esclusivamente flussi e fonti energetiche **significative e comparabili**.

## Struttura della dashboard

La dashboard è composta da:

- 4 KPI cards
- 3 grafici principali 
- 2 slicer

Questa struttura garantisce un buon equilibrio tra **informazione, leggibilità e immediatezza**.

<p align="center">
  <img src="dashboard_overview.png"
       alt="Vista complessiva della dashboard"
       width="900">
</p>
<p align="center">
  <em>Vista complessiva della dashboard</em>
</p>

## Slicers

La dashboard utilizza **due slicers**, per mantenere semplicità e controllo. Lo slicer `Paese` si applica nei seguenti campi:

- 4 KPI
- Trend sulla produzione totale
- Trend del mix energetico

Lo slicer `Solo_rinnovabili` agisce esclusivamente sul grafico Top 10, ricalcolando la classifica in base al tipo di fonte selezionato.

Non vengono utilizzati slicers su:
- anno  
- flow type  
- singole fonti energetiche

## KPI cards

Le 4 KPI cards sono realizzate in Excel come **celle formattate**, alimentate da **misure DAX** e tabelle pivot.

<p align="center">
  <img src="KPIs.png"
       alt="KPI principali"
       width="900">
</p>
<p align="center">
  <em>KPI principali</em>
</p>

- **Total Produced (GWh)**  
  Misura la produzione complessiva.

- **Renewable Share (%)**  
  KPI core di transizione energetica, calcolato sulla produzione totale.

- **Rolling 3Y Total Production (GWh)**  
  Rappresenta il trend strutturale della produzione, riducendo la volatilità annuale.

- **Deviation vs Rolling 3Y (GWh)**  
  Evidenzia shock energetici o anomalie rispetto al trend di lungo periodo.

Queste KPI variano in base al paese selezionato tramite lo slicer geografico.

## Trend temporale della produzione per paese

Questo grafico confronta l’andamento storico della produzione con il trend strutturale depurato dal rumore annuale.

<p align="center">
  <img src="trend_total_country.png"
       alt="Evoluzione temporale della produzione elettrica con media mobile a 3 anni"
       width="850">
</p>
<p align="center">
  <em>Evoluzione della produzione elettrica con media mobile a 3 anni</em>
</p>

La media mobile a tre anni sostituisce l’analisi anno per anno, rendendo il trend più stabile e leggibile.

## Evoluzione del mix energetico per paese

Questo grafico mostra come cambia la composizione della produzione elettrica nel tempo.

<p align="center">
  <img src="trend_mix_country.png"
       alt="Mix energetico rinnovabili vs non rinnovabili"
       width="850">
</p>
<p align="center">
  <em>Evoluzione del mix energetico: rinnovabili vs non rinnovabili</em>
</p>

Non vengono mostrati dettagli per singola fonte per evitare eccessiva granularità e mantenere il focus sul messaggio principale.

## Top 10 paesi per contributo energetico e per tipo di fonte energetica

Il grafico a barre evidenzia i principali paesi che hanno contribuito alla crescita della produzione elettrica globale nell'intero arco temporale disponibile. La classifica viene ricalcolata in base al flag selezionato tramite lo slicer `is_renewable`, per limitare l’analisi alle fonti rinnovabili o non rinnovabili.

<p align="center">
  <img src="top_10.png"
       alt="Mix energetico rinnovabili vs non rinnovabili"
       width="550">
</p>
<p align="center">
  <em>Maggiori contributi in produzione elettrica nell'intero periodo disponibile</em>
</p>

## Principi di design

La dashboard segue alcuni principi chiave:

- Single source of truth:  
  Tutte le KPI derivano da `total_produced_gwh`.

- Minimalismo: 
  Pochi visual, ciascuno con un messaggio chiaro.

- Stabilità:  
  Le medie mobili sono preferite ai confronti YoY.

- Comparabilità: 
  KPI coerenti tra paesi e nel tempo.

## Principali evidenze

- La produzione elettrica totale aumenta in modo marcato a partire dal 2016–2017, per poi stabilizzarsi fino al 2023.
- Nella maggior parte dei paesi analizzati non emerge un trend chiaro di crescita della quota percentuale di rinnovabili.
- La classifica dei principali produttori rimane stabile nel tempo, con Cina, USA e India dominanti sia nelle rinnovabili che nelle non rinnovabili.
- La Cina è costantemente il primo produttore globale; il Brasile si distingue per un’elevata produzione rinnovabile complessiva nel periodo.

### Limiti dell’analisi

- Le fonti etichettate come *electricity* sono state classificate come non rinnovabili; trattandosi di una categoria aggregata, la produzione rinnovabile potrebbe risultare sottostimata.
- L’assenza di un chiaro aumento della quota di rinnovabili suggerisce che la crescita della produzione elettrica non sia stata accompagnata da una transizione strutturale evidente.
- L’incremento della produzione totale osservato dal 2016–2017 è probabilmente influenzato da una maggiore completezza dei dati negli anni più recenti.
- I livelli produttivi precedenti al 2016 risultano quindi meno affidabili per via della copertura incompleta.
- La Top 10 dei paesi produttori è altamente persistente; la Cina guida tutte le metriche, mentre il Brasile supera l’India nella produzione rinnovabile cumulata.


*Torna al [README](/readme.it.md)*