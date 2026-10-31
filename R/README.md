# R scripts

Scripts are organised as a reproducible workflow. Run them from the repository root after importing the authorised source dataset locally.

## Current script

1. `01_data_audit_cleaning.R` — inspects the imported `agro_dat` object; identifies and removes completely empty columns from a separate working copy; checks exact duplicate rows and repeated `Number` identifiers; summarises missing values; and describes the `Farmtypes` and `Structuraldata` classifications.

The script does not import a source file because the original file format, path, and source documentation have not yet been confirmed. It expects the dataset to be loaded in R as `agro_dat`. It preserves the original object and does not delete observations, impute missing values, or replace missing values with zero.

## Planned scripts

2. `02_validate_variables.R` — document variable definitions, units, valid ranges, category coding, and internal consistency after reviewing the codebook.
3. `03_descriptive_analysis.R` — summarise the prevalence of agroecological practices using appropriate denominators.
4. `04_visualise_adoption.R` — create labelled charts and explore practice co-occurrence.
5. `05_additional_analysis.R` — run a justified statistical test or model, if appropriate.

Use relative paths and explain important analytical decisions in comments. Do not assume variable meanings or recode values until the dataset documentation has been reviewed.
