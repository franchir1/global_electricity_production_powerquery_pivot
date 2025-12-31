# ETL – Power Query / Power Pivot

Questo documento descrive la fase di **ETL (Extract, Transform, Load)** del progetto di analisi della produzione elettrica globale, implementata tramite **Power Query** e caricata nel modello dati **Power Pivot**.

## Obiettivo della fase ETL

La fase ETL ha l’obiettivo di:

- importare il dataset grezzo in formato CSV
- garantire coerenza strutturale e semantica dei dati
- preparare il dataset per il modello dimensionale e il calcolo delle KPI

## Sintesi del processo ETL

- importazione controllata del file CSV
- utilizzo della prima riga come intestazioni di colonna
- tipizzazione esplicita dei campi per aggregazioni corrette
- normalizzazione del dataset a livello di fact table
- caricamento dei dati nel modello per l’integrazione con le dimensioni

## Source Type Mapping

La colonna `product` viene successivamente mappata su una tabella di classificazione delle fonti energetiche (`source_type mapping`), utilizzata per distinguere:

* fonti rinnovabili vs non rinnovabili
* voci core vs contesto
* elementi da escludere dal modello analitico

### Mappatura delle fonti energetiche

|     source_type    | source_category | is_renewable | Ruolo nel modello |              Descrizione             |
| :----------------: | :-------------: | :----------: | :---------------: | :----------------------------------: |
|        Coal        |  Non-Renewable  |     FALSE    |      KPI core     |    Produzione elettrica da carbone   |
|         Oil        |  Non-Renewable  |     FALSE    |      KPI core     |   Produzione elettrica da petrolio   |
|     Natural Gas    |  Non-Renewable  |     FALSE    |      KPI core     | Produzione elettrica da gas naturale |
|       Nuclear      |  Non-Renewable  |     FALSE    |      KPI core     |     Produzione elettrica nucleare    |
|        Hydro       |    Renewable    |     TRUE     |      KPI core     |       Produzione idroelettrica       |
|        Wind        |    Renewable    |     TRUE     |      KPI core     |           Produzione eolica          |
|        Solar       |    Renewable    |     TRUE     |      KPI core     |           Produzione solare          |
|     Geothermal     |    Renewable    |     TRUE     |      KPI core     |         Produzione geotermica        |
|  Other Renewables  |    Renewable    |     TRUE     |      Contesto     |       Fonti rinnovabili minori       |
|     Electricity    |    Aggregate    |     FALSE    |      Contesto     |           Totale aggregato           |
| Other combustibles |    Aggregate    |     FALSE    |      Contesto     |         Totale fonti fossili         |
|  Total renewables  |    Aggregate    |     TRUE     |      Contesto     |          Totale rinnovabili          |
|    Not Specified   |   Da escludere  |     FALSE    |      Rimosso      |        Fonte non classificata        |
|    Estimate Flag   |     Metadato    |     FALSE    |      Rimosso      |          Indicatore di stima         |

### Logica di utilizzo

* Le KPI di transizione energetica sono basate sul flag `is_renewable`
* Le voci aggregate sono mantenute per coerenza di volume ma escluse dalle classificazioni
* Le voci marcate come *Rimosso* non entrano nel modello analitico

## Flow Type Mapping

Il campo `parameter` identifica il tipo di flusso energetico. Anche questo viene gestito tramite una tabella di mapping dedicata.

### Mappatura dei flussi

|   flow_type  |         Descrizione tecnica        | Ruolo analitico |
| :----------: | :--------------------------------: | :-------------: |
| net_produced | Produzione elettrica netta interna |     KPI core    |
|   exported   |     Energia elettrica esportata    |     KPI core    |
|   imported   |     Energia elettrica importata    |     Contesto    |
|     lost     |      Perdite di distribuzione      |     Contesto    |
|    stored    |        Energia per accumulo        |     Contesto    |
|   consumed   |      Consumo finale calcolato      |     Contesto    |
|    remarks   |           Voci residuali           |     Escluso     |

### Scelte analitiche

* Approccio **production-first**
* KPI basate esclusivamente su `net_produced` ed `exported`
* Misura di riferimento:

`total_produced = net_produced + exported`

* I flussi non produttivi sono esclusi dalle KPI core ma disponibili per analisi di contesto

## Output della fase ETL

Al termine della fase ETL il modello dispone di:

* una fact table coerente e tipizzata
* classificazioni semantiche separate dal dato grezzo
* una base solida per DAX, Power Pivot e dashboard analitiche

*Torna al [README](/readme.it.md)*