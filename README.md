# Global Electricity Production — Data Analysis with Excel Power Pivot

Analysis of the evolution of global electricity production, with a focus on
**energy transition** and the **stability of long-term trends**.

The project is designed as a **portfolio analysis** and emphasizes:
- dimensional data modeling
- KPI semantic consistency
- temporal comparability
- decision-oriented reporting

---

## Project Objective

The goal is to provide a **concise, stable, and time-comparable** view of the
global electricity production system, addressing questions such as:

- How does global electricity production evolve over the long term?
- What is the relative contribution of renewable vs non-renewable sources?
- Are observed trends structural or driven by annual volatility?
- Are there significant cross-country differences in energy mix?
- Is renewable growth proportional to total production or geographically concentrated?

The approach is **KPI-driven** and prioritizes **stability and interpretability**
over transactional detail.

---

## Dataset

The source dataset contains:

- country
- date (used exclusively to extract the year)
- energy flow type
- energy source
- produced energy quantity (GWh)

The dataset is **not normalized** and requires a full ETL process before
analytical use.

---

## Data Cleaning & Transformation

All transformations are implemented in **Power Query** and include:

1. CSV import
2. explicit data type conversion
3. category normalization:
   - energy sources
   - energy flows
4. year extraction from date
5. creation of dimension tables
6. construction of a fact table with **surrogate keys**
7. exclusion of non-analytical fields from core KPIs

The result is a **repeatable and stable analytical model**, optimized for
long-term analysis.

---

## Data Model

The model follows a **star schema** structure, composed of:

- a **fact table** containing energy quantities
- dimension tables for:
  - geography
  - time
  - energy source
  - flow type

*(schema diagram unchanged)*

Relationships are:
- one-to-many
- single-direction

---

## KPIs & Analytical Logic

Key metrics are designed to ensure **semantic consistency and comparability**:

- total electricity production
- renewable energy share
- time trends via a **3-year rolling average**
- cross-country comparisons on a consistent basis

Metrics are intentionally designed to emphasize **structural patterns**
rather than year-to-year noise.

---

## Dashboard

An **analytical dashboard** is built in Excel using **Power Pivot**.

The dashboard provides:
- an overview of core energy indicators
- stable temporal analyses
- cross-country and cross-source comparisons

*(dashboard image unchanged)*

---

## Methodological Choices

- Core KPIs are based on **total electricity production**, defined as the sum of:
  - net production
  - exported energy
- Other flow types are excluded from the analytical core, as they represent
  usage, losses, or system exchanges
- **3-year rolling averages** are used to reduce volatility and improve
  interpretability of medium-term dynamics

The project prioritizes **analytical stability** over maximizing detail.

---

## Key Findings

- Growth in global electricity production is concentrated in countries with
  the largest absolute volumes, with rankings remaining broadly stable over time.
- In most selected countries, no clear structural trend emerges in renewable
  share growth (percentage).
- A sharp increase in total production appears starting in 2016–2017, followed
  by stabilization through 2023.
- Pre-2016 dynamics are less reliable due to incomplete data coverage.
- Aggregated energy categories may lead to an underestimation of renewable output.
- Rolling averages significantly improve trend readability.

---

## Legacy Excel Version

The repository includes an initial implementation based on **traditional Excel**
(formulas and manual calculations).

This version is intentionally preserved to:
- document project evolution
- expose calculation logic
- highlight scalability limits of non-modeled approaches

The final solution is based on **Power Query and Power Pivot**.

---

## Tools & Technologies

- **ETL:** Excel Power Query
- **Data modeling & analytics:** Excel Power Pivot, DAX
- **IDE:** Visual Studio Code
- **Version control:** Git / GitHub

---

## Skills Demonstrated

- star schema data modeling
- ETL design in Power Query
- DAX measure development
- energy systems analytics
- time-stable KPI design
- structured technical documentation

---

## Documentation & Deep Dives

- Legacy Excel-based analysis  
  [`00_legacy_excel_traditional/README.md`](00_legacy_excel_traditional/README.md)

- Raw source data  
  [`01_raw_data/`](01_raw_data/global_electricity_production_data_1k.csv)  
  Full dataset available on Kaggle

- ETL documentation  
  [`03_etl/etl.md`](03_etl/etl.md)

- Data model documentation  
  [`04_data_model/model_overview.md`](04_data_model/model_overview.md)

- DAX measures  
  [`05_dax/dax.md`](05_dax/dax.md)

- Dashboard explanation  
  [`06_dashboard/dashboard_overview.md`](06_dashboard/dashboard_overview.md)

- Excel file
  ['global_electricity_production_report'](/02_clean_data/global_electricity_production_report.xlsx)
