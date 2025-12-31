## Measures and KPIs

This section describes the **DAX measures used in the model** and the **KPIs exposed in the dashboard**.
All listed measures derive from the fact table and are consistent with the analytical scope
defined in the previous chapters.

### Measures list

| Business name                  | DAX measure name                  | Description                                                               |
| :------------------------------ | :-------------------------------- | :------------------------------------------------------------------------- |
| Total Energy (GWh)             | `total_gwh`                      | Total energy quantity recorded in the fact table.                         |
| Exported (GWh)                 | `exported_gwh`                   | Exported electricity.                                                     |
| Net Produced (GWh)             | `net_produced_gwh`               | Net domestic electricity production.                                      |
| Total Produced (GWh)           | `total_produced_gwh`             | Total electricity production (net_produced + exported).                   |
| Renewable Production (GWh)     | `renewable_gwh`                  | Total electricity production from renewable sources.                      |
| Non-Renewable Production (GWh) | `non_renewable_gwh`              | Total electricity production from non-renewable sources.                  |
| Renewable Share (%)            | `renewable_pct`                  | Percentage share of renewable production over total produced.             |
| Rolling 3Y Total Production    | `rolling_3y_total_gwh`           | 3-year rolling average of total production.                               |
| Deviation vs Rolling 3Y (GWh)  | `rolling_3y_total_gwh_deviation` | Absolute deviation from the 3-year rolling average.                       |
| Delta Produced (GWh)           | `delta_produced_gwh`             | Absolute production change between the first and last selected year.      |

## DAX measure definitions

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

*Torna al [README](/readme.md)*