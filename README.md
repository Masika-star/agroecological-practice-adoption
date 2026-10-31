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

So far, I have practised using the tidyverse to inspect and organise data. I am becoming more comfortable with pipes (`|>`), `select()`, `count()`, `summarise()`, `across()`, `pivot_longer()`, `mutate()`, and `arrange()`.

My main takeaway is that data cleaning is not just removing blanks. I need to understand what a value means before deciding whether to keep it, change it, or treat it as missing.

## What I am working on next

1. Find out whether the 24 missing livestock records are the same across all four livestock-related variables.
2. Compare those records with `LivestockUBT` and farm type.
3. Investigate the one missing value in permanent hired workers.
4. Check variable definitions, units, valid ranges, and unusual values.
5. Move on to exploring the 15 agroecological indicators.

## Reproducible work

I have started recording the work in an R script: [`R/01_data_audit_cleaning.R`](R/01_data_audit_cleaning.R).

I also keep a short account of my findings in [`reports/initial-data-quality-audit.md`](reports/initial-data-quality-audit.md).

The source dataset is not stored in this repository. I will only share it if its licence and access conditions permit redistribution. For now, the R script expects me to load the authorised data locally as `agro_dat`.

---

**My approach:** understand the data first, make cleaning decisions carefully, and only then move to analysis.
