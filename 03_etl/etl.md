# ETL – Power Query / Power Pivot

This document describes the **ETL (Extract, Transform, Load)** phase of the global electricity production analysis project, implemented with **Power Query** and loaded into the **Power Pivot** data model.

## ETL phase objective

The ETL phase aims to:

- import the raw dataset in CSV format
- ensure structural and semantic consistency of the data
- prepare the dataset for dimensional modeling and KPI calculation

## ETL process summary

- controlled import of the CSV file
- use the first row as column headers
- explicit typing of fields for correct aggregations
- dataset normalization at fact table level
- load data into the model for integration with dimensions

## Source Type Mapping

The `product` column is subsequently mapped to an energy source classification table (`source_type mapping`), used to distinguish:

- renewable vs non-renewable sources
- core vs context entries
- elements to exclude from the analytical model

### Energy source mapping

| source_type | source_category | is_renewable | Model role | Description |
|:--:|:--:|:--:|:--:|:--:|
| Coal | Non-Renewable | FALSE | Core KPI | Electricity production from coal |
| Oil | Non-Renewable | FALSE | Core KPI | Electricity production from oil |
| Natural Gas | Non-Renewable | FALSE | Core KPI | Electricity production from natural gas |
| Nuclear | Non-Renewable | FALSE | Core KPI | Nuclear electricity production |
| Hydro | Renewable | TRUE | Core KPI | Hydroelectric production |
| Wind | Renewable | TRUE | Core KPI | Wind power production |
| Solar | Renewable | TRUE | Core KPI | Solar power production |
| Geothermal | Renewable | TRUE | Core KPI | Geothermal production |
| Other Renewables | Renewable | TRUE | Context | Minor renewable sources |
| Electricity | Aggregate | FALSE | Context | Aggregated total |
| Other combustibles | Aggregate | FALSE | Context | Total fossil fuels |
| Total renewables | Aggregate | TRUE | Context | Total renewables |
| Not Specified | To exclude | FALSE | Removed | Unclassified source |
| Estimate Flag | Metadata | FALSE | Removed | Estimation indicator |

### Usage logic

- Energy transition KPIs are based on the `is_renewable` flag
- Aggregate entries are kept for volume consistency but excluded from classifications
- Entries marked as *Removed* do not enter the analytical model

## Flow Type Mapping

The `parameter` field identifies the energy flow type. This is also managed via a dedicated mapping table.

### Flow mapping

| flow_type | Technical description | Analytical role |
|:--:|:--|:--:|
| net_produced | Net domestic electricity production | Core KPI |
| exported | Exported electricity | Core KPI |
| imported | Imported electricity | Context |
| lost | Distribution losses | Context |
| stored | Energy for storage | Context |
| consumed | Calculated final consumption | Context |
| remarks | Residual entries | Excluded |

### Analytical choices

- **Production-first** approach
- KPIs based exclusively on `net_produced` and `exported`
- Reference measure:

`total_produced = net_produced + exported`

- Non-production flows are excluded from core KPIs but available for context analyses

## ETL output

At the end of the ETL phase, the model provides:

- a consistent and typed fact table
- semantic classifications separated from raw data
- a solid foundation for DAX, Power Pivot, and analytical dashboards

*Back to the [README](/readme.md)*

