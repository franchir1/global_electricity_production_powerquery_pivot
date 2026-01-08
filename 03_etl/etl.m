// raw data loading
// raw data loading

let
    // Import CSV (source NOT modified)
    Source =
        Csv.Document(
            File.Contents("C:\Users\Lenovo\Desktop\global_electricity_production_data.csv"),
            [
                Delimiter = ",",
                Columns = 6,
                Encoding = 1252,
                QuoteStyle = QuoteStyle.None
            ]
        ),

    // Use first row as headers
    PromoteHeaders =
        Table.PromoteHeaders(
            Source,
            [PromoteAllScalars = true]
        ),

    // Apply correct data types
    Typed =
        Table.TransformColumnTypes(
            PromoteHeaders,
            {
                {"country_name", type text},
                {"date", type date},
                {"parameter", type text},
                {"product", type text},
                {"value", type number},
                {"unit", type text}
            }
        ),

    // Trim text columns
    Trimmed =
        Table.TransformColumns(
            Typed,
            {
                {"country_name", Text.Trim, type text},
                {"parameter", Text.Trim, type text},
                {"product", Text.Trim, type text},
                {"unit", Text.Trim, type text}
            }
        ),

    // Rename value column for semantic consistency
    RenameValue =
        Table.RenameColumns(
            Trimmed,
            {{"value", "quantity_gwh"}}
        )

in
    RenameValue


// country_dim

let
    Source = gepr_raw,

    // Keep only original country column
    OnlyCountry =
        Table.SelectColumns(Source, {"country_name"}),

    // Remove duplicates
    DistinctCountry =
        Table.Distinct(OnlyCountry),

    // Rename to "country"
    Renamed =
        Table.RenameColumns(
            DistinctCountry,
            {{"country_name", "country"}}
        ),

    // Add surrogate key
    WithKey =
        Table.AddIndexColumn(
            Renamed,
            "country_key",
            0,
            1,
            Int64.Type
        ),

    // Reorder columns
    CountryDim =
        Table.ReorderColumns(
            WithKey,
            {"country_key", "country"}
        )
in
    CountryDim


// year_dim

// year_dim

let
    Source = gepr_raw,

    // Extract date column
    OnlyDate =
        Table.SelectColumns(Source, {"date"}),

    // Extract year
    AddYear =
        Table.AddColumn(
            OnlyDate,
            "year",
            each Date.Year([date]),
            Int64.Type
        ),

    // Keep only year
    Years =
        Table.SelectColumns(AddYear, {"year"}),

    // Remove duplicates
    DistinctYears =
        Table.Distinct(Years),

    // Sort years ascending
    Sorted =
        Table.Sort(DistinctYears, {{"year", Order.Ascending}}),

    // Add surrogate key
    WithKey =
        Table.AddIndexColumn(
            Sorted,
            "year_key",
            0,
            1,
            Int64.Type
        ),

    // Reorder columns
    Output =
        Table.ReorderColumns(
            WithKey,
            {"year_key", "year"}
        )
in
    Output


// flow_type_dim
// flow_type_dim

let
    Source = gepr_raw,

    // Keep only parameter column
    OnlyType =
        Table.SelectColumns(Source, {"parameter"}),

    // Normalize flow types
    AddFlowType =
        Table.AddColumn(
            OnlyType,
            "flow_type",
            each
                if [parameter] = "Net Electricity Production" then "net_produced"
                else if [parameter] = "Used for pumped storage" then "stored"
                else if [parameter] = "Distribution Losses" then "lost"
                else if [parameter] = "Final Consumption (Calculated)" then "consumed"
                else if [parameter] = "Total Imports" then "imported"
                else if [parameter] = "Total Exports" then "exported"
                else if [parameter] = "Remarks" then "remarks"
                else null,
            type text
        ),

    // Keep only normalized flow type
    SelectFlow =
        Table.SelectColumns(AddFlowType, {"flow_type"}),

    // Remove nulls and duplicates
    Clean =
        Table.Distinct(
            Table.SelectRows(SelectFlow, each [flow_type] <> null)
        ),

    // Add surrogate key
    WithKey =
        Table.AddIndexColumn(
            Clean,
            "flow_type_key",
            0,
            1,
            Int64.Type
        ),

    // Reorder columns
    Output =
        Table.ReorderColumns(
            WithKey,
            {"flow_type_key", "flow_type"}
        )
in
    Output


// source_type_dim

// source_type_dim

let
    Source = gepr_raw,

    // Keep original product column
    Base =
        Table.SelectColumns(Source, {"product"}),

    // Normalize energy source types
    AddType =
        Table.AddColumn(
            Base,
            "source_type",
            each
                if [product] = "Electricity" then "electricity"
                else if [product] = "Coal, Peat and Manufactured Gases" then "coal"
                else if [product] = "Oil and Petroleum Products" then "oil"
                else if [product] = "Natural Gas" then "natural_gas"
                else if [product] = "Combustible Renewables" then "renewable_combustibles"
                else if [product] = "Hydro" then "hydro"
                else if [product] = "Wind" then "wind"
                else if [product] = "Solar" then "solar"
                else if [product] = "Geothermal" then "geo"
                else if Text.StartsWith([product], "Total Renewables") then "mixed_renewables"
                else if [product] = "Not Specified" then "not_specified"
                else if [product] = "Nuclear" then "nuclear"
                else "combustible_fuels",
            type text
        ),

    // Keep only normalized source type
    TypesOnly =
        Table.SelectColumns(AddType, {"source_type"}),

    // Remove duplicates
    DistinctTypes =
        Table.Distinct(TypesOnly),

    // Add renewable flag
    AddIsRenewable =
        Table.AddColumn(
            DistinctTypes,
            "is_renewable",
            each
                List.Contains(
                    {
                        "renewable_combustibles",
                        "hydro",
                        "wind",
                        "solar",
                        "geo",
                        "mixed_renewables"
                    },
                    [source_type]
                ),
            type logical
        ),

    // Add aggregate flag
    AddIsAggregate =
        Table.AddColumn(
            AddIsRenewable,
            "is_aggregate",
            each
                List.Contains(
                    {"electricity", "mixed_renewables"},
                    [source_type]
                ),
            type logical
        ),

    // Add surrogate key
    AddKey =
        Table.AddIndexColumn(
            AddIsAggregate,
            "source_type_key",
            0,
            1,
            Int64.Type
        ),

    // Final column order
    Final =
        Table.ReorderColumns(
            AddKey,
            {"source_type_key", "source_type", "is_renewable", "is_aggregate"}
        )
in
    Final


// fact_table
// fact_table

let
    //-----------------------------------------------------------------------
    // SOURCE
    //-----------------------------------------------------------------------
    Source = gepr_raw,

    //-----------------------------------------------------------------------
    // YEAR
    //-----------------------------------------------------------------------
    AddYear =
        Table.AddColumn(
            Source,
            "year",
            each Date.Year([date]),
            Int64.Type
        ),

    //-----------------------------------------------------------------------
    // NORMALIZED SOURCE TYPE (same logic as source_type_dim)
    //-----------------------------------------------------------------------
    AddSourceType =
        Table.AddColumn(
            AddYear,
            "source_type",
            each
                if [product] = "Electricity" then "electricity"
                else if [product] = "Coal, Peat and Manufactured Gases" then "coal"
                else if [product] = "Oil and Petroleum Products" then "oil"
                else if [product] = "Natural Gas" then "natural_gas"
                else if [product] = "Combustible Renewables" then "renewable_combustibles"
                else if [product] = "Hydro" then "hydro"
                else if [product] = "Wind" then "wind"
                else if [product] = "Solar" then "solar"
                else if [product] = "Geothermal" then "geo"
                else if Text.StartsWith([product], "Total Renewables") then "mixed_renewables"
                else if [product] = "Not Specified" then "not_specified"
                else if [product] = "Nuclear" then "nuclear"
                else "combustible_fuels",
            type text
        ),

    //-----------------------------------------------------------------------
    // NORMALIZED FLOW TYPE (same logic as flow_type_dim)
    //-----------------------------------------------------------------------
    AddFlowType =
        Table.AddColumn(
            AddSourceType,
            "flow_type",
            each
                if [parameter] = "Net Electricity Production" then "net_produced"
                else if [parameter] = "Used for pumped storage" then "stored"
                else if [parameter] = "Distribution Losses" then "lost"
                else if [parameter] = "Final Consumption (Calculated)" then "consumed"
                else if [parameter] = "Total Imports" then "imported"
                else if [parameter] = "Total Exports" then "exported"
                else if [parameter] = "Remarks" then "remarks"
                else null,
            type text
        ),

    //-----------------------------------------------------------------------
    // BASE FACT COLUMNS
    //-----------------------------------------------------------------------
    BaseFact =
        Table.SelectColumns(
            AddFlowType,
            {
                "country_name",
                "quantity_gwh",
                "year",
                "source_type",
                "flow_type"
            }
        ),

    RenameCountry =
        Table.RenameColumns(
            BaseFact,
            {{"country_name", "country"}}
        ),

    //-----------------------------------------------------------------------
    // JOIN COUNTRY DIM
    //-----------------------------------------------------------------------
    JoinCountry =
        Table.NestedJoin(
            RenameCountry,
            {"country"},
            country_dim,
            {"country"},
            "country_dim",
            JoinKind.LeftOuter
        ),

    ExpandCountry =
        Table.ExpandTableColumn(
            JoinCountry,
            "country_dim",
            {"country_key"},
            {"country_key"}
        ),

    RemoveCountry =
        Table.RemoveColumns(
            ExpandCountry,
            {"country"}
        ),

    //-----------------------------------------------------------------------
    // JOIN YEAR DIM
    //-----------------------------------------------------------------------
    JoinYear =
        Table.NestedJoin(
            RemoveCountry,
            {"year"},
            year_dim,
            {"year"},
            "year_dim",
            JoinKind.LeftOuter
        ),

    ExpandYear =
        Table.ExpandTableColumn(
            JoinYear,
            "year_dim",
            {"year_key"},
            {"year_key"}
        ),

    RemoveYear =
        Table.RemoveColumns(
            ExpandYear,
            {"year"}
        ),

    //-----------------------------------------------------------------------
    // JOIN FLOW TYPE DIM
    //-----------------------------------------------------------------------
    JoinFlow =
        Table.NestedJoin(
            RemoveYear,
            {"flow_type"},
            flow_type_dim,
            {"flow_type"},
            "flow_type_dim",
            JoinKind.LeftOuter
        ),

    ExpandFlow =
        Table.ExpandTableColumn(
            JoinFlow,
            "flow_type_dim",
            {"flow_type_key"},
            {"flow_type_key"}
        ),

    RemoveFlow =
        Table.RemoveColumns(
            ExpandFlow,
            {"flow_type"}
        ),

    //-----------------------------------------------------------------------
    // JOIN SOURCE TYPE DIM
    //-----------------------------------------------------------------------
    JoinSource =
        Table.NestedJoin(
            RemoveFlow,
            {"source_type"},
            source_type_dim,
            {"source_type"},
            "source_type_dim",
            JoinKind.LeftOuter
        ),

    ExpandSource =
        Table.ExpandTableColumn(
            JoinSource,
            "source_type_dim",
            {"source_type_key"},
            {"source_type_key"}
        ),

    RemoveSource =
        Table.RemoveColumns(
            ExpandSource,
            {"source_type"}
        ),

    //-----------------------------------------------------------------------
    // FINAL FACT TABLE
    //-----------------------------------------------------------------------
    Fact =
        Table.ReorderColumns(
            RemoveSource,
            {
                "quantity_gwh",
                "country_key",
                "year_key",
                "flow_type_key",
                "source_type_key"
            }
        )
in
    Fact
