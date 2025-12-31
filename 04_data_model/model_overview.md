# Data Model Overview

This document describes the star schema data model built with Power Query and Power Pivot.

## Overall architecture

The model adopts a star schema consisting of:
- one central fact table
- four dimension tables
- one-to-many relationships from dimensions to the fact table

<p align="center">
  <img src="star_scheme.png"
       alt="Star schema of the data model - fact table and dimensions"
       width="700">
</p>
<p align="center">
  <em>Star schema of the data model - fact table and dimensions</em>
</p>

This setup makes the project:
- analytically robust
- easily extensible

## Fact table

The fact table contains the model’s quantitative values and foreign keys to dimensions.

| Field | Type | Description |
|:-|:-|:-|
| `quantity_gwh` | Number | Energy quantity in GWh |
| `country_key` | Integer | Reference to `country_dim` |
| `year_key` | Integer | Reference to `year_dim` |
| `source_type_key` | Integer | Reference to `source_type_dim` |
| `flow_type_key` | Integer | Reference to `flow_type_dim` |

Analytical logic is delegated to dimensions and DAX measures.

## Dimension tables

### country_dim
Geographic context for cross-country comparisons and rankings.

### year_dim
Time context used for historical analysis.

### source_type_dim
Classifies energy sources and enables energy transition analysis.

### flow_type_dim
Defines the nature of the energy flow and allows separating KPIs from context indicators.

*Back to the [README](/readme.md)*
