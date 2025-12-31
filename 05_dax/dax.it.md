## Misure e KPI

Questa sezione descrive le **misure DAX utilizzate nel modello** e le **KPI esposte nella dashboard**.
Tutte le misure elencate derivano dalla fact table e sono coerenti con l’ambito
di analisi definito nei capitoli precedenti.


### Elenco delle misure

### Elenco delle misure

| Nome business                  | Nome misura DAX                  | Descrizione                                                               |
| :------------------------------ | :-------------------------------- | :------------------------------------------------------------------------- |
| Total Energy (GWh)             | `total_gwh`                      | Quantità totale di energia registrata nella fact table.                   |
| Exported (GWh)                 | `exported_gwh`                   | Energia elettrica esportata.                                               |
| Net Produced (GWh)             | `net_produced_gwh`               | Produzione elettrica netta interna.                                        |
| Total Produced (GWh)           | `total_produced_gwh`             | Produzione elettrica totale (net_produced + exported).                    |
| Renewable Production (GWh)     | `renewable_gwh`                  | Produzione totale da fonti rinnovabili.                                    |
| Non-Renewable Production (GWh) | `non_renewable_gwh`              | Produzione totale da fonti non rinnovabili.                                |
| Renewable Share (%)            | `renewable_pct`                  | Quota percentuale di produzione rinnovabile sul totale prodotto.          |
| Rolling 3Y Total Production    | `rolling_3y_total_gwh`           | Media mobile a 3 anni della produzione totale.                             |
| Deviation vs Rolling 3Y (GWh)  | `rolling_3y_total_gwh_deviation` | Scostamento assoluto dalla media mobile a 3 anni.                          |
| Delta Produced (GWh)           | `delta_produced_gwh`             | Variazione assoluta della produzione tra primo e ultimo anno selezionato. |



## Definizione delle misure DAX

### `total_gwh`

Misura atomica che rappresenta la quantità totale di energia registrata nella fact table.

```DAX
total_gwh :=
SUM ( fact_table[quantity_gwh] )
```



### `exported_gwh`

Energia elettrica esportata.

```DAX
exported_gwh :=
CALCULATE (
    [total_gwh],
    flow_type_dim[flow_type] = "exported"
)
```


### `net_produced_gwh`

Produzione elettrica netta interna.

```DAX
net_produced_gwh :=
CALCULATE (
    [total_gwh],
    flow_type_dim[flow_type] = "net_produced"
)
```



### `total_produced_gwh`

Produzione elettrica totale utilizzata come misura di riferimento nel modello.

```DAX
total_produced_gwh :=
[net_produced_gwh] + [exported_gwh]
```



### `renewable_gwh`

Produzione elettrica da fonti rinnovabili.

```DAX
renewable_gwh :=
CALCULATE (
    [total_produced_gwh],
    source_type_dim[is_renewable] = TRUE
)
```



### `non_renewable_gwh`

Produzione elettrica da fonti non rinnovabili.

```DAX
non_renewable_gwh :=
CALCULATE (
    [total_produced_gwh],
    source_type_dim[is_renewable] = FALSE
)
```



### `renewable_pct`

```DAX
renewable_pct :=
CALCULATE (
    DIVIDE ( [renewable_gwh], [total_produced_gwh] ),
    ALL ( source_type_dim[is_renewable] )
)
```



### `rolling_3y_total_gwh`

```DAX
rolling_3y_total_gwh :=
VAR CurrentYear =
    MAX ( year_dim[year] )
VAR Window =
    FILTER (
        ALLSELECTED ( year_dim[year] ),
        year_dim[year] >= CurrentYear - 2
            && year_dim[year] <= CurrentYear
    )
RETURN
AVERAGEX (
    Window,
    CALCULATE ( [total_produced_gwh] )
)
```



### `rolling_3y_total_gwh_deviation`

```DAX
rolling_3y_total_gwh_deviation_gwh :=
[total_produced_gwh] - [rolling_3y_total_gwh]
```



### `delta_produced_gwh`

```DAX
delta_produced_gwh :=
VAR first_year =
    MIN ( year_dim[year] )
VAR last_year =
    MAX ( year_dim[year] )
RETURN
    CALCULATE (
        [total_produced_gwh],
        year_dim[year] = last_year
    )
    - CALCULATE (
        [total_produced_gwh],
        year_dim[year] = first_year
    )
```

*Torna al [README](/readme.it.md)*