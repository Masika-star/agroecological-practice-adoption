# Agroecological Practice Adoption: My R Learning Journey

## About this project

I am using this project to strengthen my R skills while exploring a real agricultural dataset. My interest is in understanding how farmers use agroecological practices and how different practices may occur together.

I am learning by doing: asking questions of the data, writing R code, checking what the results mean, and recording what I discover.

## My progress so far

I loaded the dataset into R as `agro_dat` and began exploring it with the tidyverse. My first inspection showed **98 observations and 46 variables**.

One of my first data-cleaning discoveries was that 18 columns (`AC` to `AT`) were completely empty. I removed these from a separate working copy called `agro_clean`, leaving **98 observations and 28 variables**. I kept the original `agro_dat` unchanged.

### What I found

- The dataset contains four farm types: T1 (24 farms), T2 (25), T3 (24), and T4 (25). They are almost equally represented.
- Every observation is labelled `Structural data`. I still need to understand what this variable represents.
- I found no completely duplicated rows and no repeated observation numbers.
- Five of the 28 retained variables contain missing values. Four livestock-related variables each have 24 missing values (24.49%), while `Permanenthiredworkersu` has one (1.02%).
- The other 23 variables have no missing values.

The livestock-related missing values caught my attention. I do not yet know whether they mean that a measurement was not applicable, was not recorded, or follows a questionnaire skip pattern. I will investigate before changing anything.

## What I have learned in R

### Setting up a reproducible project

My first step in this learning journey was to create an R Project and establish a dedicated project directory on my local machine. Within that directory, I created three main folders:

- `data/` to store the source datasets and other data files.
- `code/` to keep R scripts used for importing, cleaning, and analysing data.
- `out/` to store outputs such as tables, figures, and other results.

I set up this structure to keep project materials organised, maintain a clear workflow, and make the analysis easier to reproduce. Working within an R Project also gives the work a consistent starting point, while the `here` package helps construct project-relative file paths instead of relying on computer-specific directory paths.

### Importing, exporting, and managing data

I practised using the tidyverse to inspect and organise data. I am becoming more comfortable with pipes (`|>`), `select()`, `count()`, `summarise()`, `across()`, `pivot_longer()`, `mutate()`, and `arrange()`.

I practised importing the dataset in different formats:
- Excel using `read_excel()` from `readxl`.
- Tab-delimited text using `read_delim()` from `readr`.
- I also reviewed the distinction between R's native `.RData` and `.rds` formats: `load()` is used for `.RData`, while `readRDS()` reads an `.rds` object.

One thing I noticed is that the Excel version contains **98 rows and 28 columns**, while the tab-delimited version contains **98 rows and 46 columns**. The row counts match, but the variable counts do not. I need to compare the column names and investigate why the two versions differ before treating them as equivalent.

I also practised exporting my Excel data with `write.xlsx()`. To check that the export worked as intended, I read the exported workbook back into R and compared it with the original object using `identical()`. R returned `TRUE`, confirming that the re-imported object was identical to the original.

Finally, I began creating a workbook with multiple worksheets using `createWorkbook()`, `addWorksheet()`, and `writeData()`. This gives me more control over how I organise tables for reporting.

My main takeaway is that a reliable analysis depends on more than writing code. It also requires an organised project structure, careful data handling, and checks to confirm that imported and exported data are as expected.

## What I am working on next

1. Compare the column names in the Excel and tab-delimited versions to understand why they contain different numbers of variables.
2. Find out whether the 24 missing livestock records are the same across all four livestock-related variables.
3. Compare those records with `LivestockUBT` and farm type.
4. Investigate the one missing value in permanent hired workers.
5. Check variable definitions, units, valid ranges, and unusual values.
6. Move on to exploring the 15 agroecological indicators.

## Reproducible work

I have started recording the work in an R script: [`R/01_data_audit_cleaning.R`](R/01_data_audit_cleaning.R).

I also keep a short account of my findings in [`reports/initial-data-quality-audit.md`](reports/initial-data-quality-audit.md).

The source dataset is not stored in this repository. I will only share it if its licence and access conditions permit redistribution. For now, the R script expects me to load the authorised data locally as `agro_dat`.

---

**My approach:** organise the project carefully, understand the data first, make cleaning decisions deliberately, and only then move to analysis.
