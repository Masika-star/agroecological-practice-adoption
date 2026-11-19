# Agroecological Practice Adoption: My R Learning Journey

## About this project

I am using this project to strengthen my R skills while exploring a real agricultural dataset. My interest is in understanding how farmers use agroecological practices and how different practices may occur together.

I am learning by doing: asking questions of the data, writing R code, checking what the results mean, and recording what I discover.

## My progress so far

I loaded the dataset into R as `agro_data` and began exploring it with the tidyverse. My first inspection showed **98 observations and 46 variables**.

One of my first data-cleaning discoveries was that 18 columns (`AC` to `AT`) were completely empty. I removed these from a separate working copy called `agro_clean`, leaving **98 observations and 28 variables**. I kept the original `agro_data` unchanged.

### What I found

- The dataset contains four farm types: T1 (24 farms), T2 (25), T3 (24), and T4 (25). They are almost equally represented.
- Every observation is labelled `Structural data`. I still need to understand what this variable represents.
- I found no completely duplicated rows and no repeated observation numbers.
- My initial audit identified four livestock-related variables with 24 missing values each, and one missing value in permanent hired workers.
- In my 19 November follow-up, I standardised the column names with `janitor::clean_names()`. The cleaned working dataset remains **98 observations × 28 variables**.
- I confirmed that three livestock-management indicators have missing values for the same 24 T1 farms, all of which have zero livestock UBT. This suggests those three indicators may be structurally not applicable for farms without livestock.
- I found that the single missing permanent hired-worker value belongs to Farm 16 (T1). I have retained it as missing rather than assuming it means zero.

One correction remains: the fourth variable from the initial livestock-related group is `cultivated_area_ha_livestock_ubt`. In my follow-up code, I selected `livestock_ubt` instead, which has no missing values. I therefore still need to verify the missingness pattern of the ratio variable before treating the four-variable check as complete. I have documented the distinction in my [data-quality learning log](reports/missing-values-and-data-quality-learning-log.md).

## My 19 November learning session: data quality and missing values

I continued my Pro-RUWA learning by applying the lesson on missing values and outliers to the actual agroecological dataset. I used `janitor::clean_names()` to standardise the variable names and kept the cleaned copy at 98 observations × 28 variables.

I then used `is.na()`, `sum()`, `rowSums()`, and tidyverse functions such as `summarise()`, `mutate()`, `select()`, `count()`, and `group_by()` to examine missing-value patterns. I found that three livestock-management indicators were missing together for 24 T1 farms, all with zero livestock UBT. I am treating these values as potentially structurally not applicable, retaining them as missing while awaiting confirmation from the dataset documentation. I also located the one missing permanent hired-worker value in Farm 16. I retained it as `NA` because the available information does not establish that the farm had zero permanent workers.

I learned to distinguish a genuine zero from a missing value and to check variable names carefully before writing code. I also identified one outstanding correction: the follow-up check used `livestock_ubt` instead of the related ratio variable `cultivated_area_ha_livestock_ubt`, so I have not yet reconfirmed the missingness pattern for that fourth variable.

I recorded the exercise, the decisions, and the limits of what I established in [my data-quality learning log](reports/missing-values-and-data-quality-learning-log.md).

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

### Correlation and simple linear regression

I applied the correlation and simple linear regression techniques from the Pro-RUWA course to two variables in the Viability of Agroecological Practices in Africa dataset:

- Organic matter produced per cultivated hectare (`4OMproduced(kgMS)/cultivatedarea(ha)`).
- Cultivated area fertilised with organic manure (`6Cultivatedareafertilizedwithorganicmanure(%)`).

**Correlation findings**

- Pearson correlation using all 98 farms was **-0.0423 (p = 0.679)**, indicating a negligible and statistically insignificant linear association.
- Spearman's rank correlation was **0.2997 (p = 0.002718)**, indicating a positive, statistically significant monotonic association.
- A Pearson sensitivity check excluding farm 23 produced **0.228 (p = 0.0249)**. This change indicates that the Pearson result is sensitive to that observation. Farm 23 remains in the cleaned dataset and in the main regression analysis.

**Regression findings**

I fitted a simple linear regression using all 98 complete observations. The estimated slope was **-0.00000884 (p = 0.679)**. The model had an **R-squared of 0.00179** and an **adjusted R-squared of -0.00861**, explaining approximately 0.179% of the observed variation in the outcome. The slope's 95% confidence interval included zero.

The outcome variable is stored between 0 and 1 in the dataset. Its fractional interpretation should be checked against the codebook before reporting values as percentages. The 16,000 kgMS/ha observation for farm 23 was noted and retained; outlier treatment was not part of this exercise.

This practical helped me distinguish linear association from monotonic association, interpret a regression slope and intercept, and understand the difference between statistical significance and explanatory power. It also reinforced that correlation and regression do not establish causation.

I used the `broom` package to organise regression output:
- `tidy()` for coefficient estimates and confidence intervals.
- `glance()` for R-squared, adjusted R-squared and overall model statistics.
- `augment()` for fitted values and residuals.

## What I am working on next

1. Complete the outstanding missingness check for `cultivated_area_ha_livestock_ubt`.
2. Continue the Pro-RUWA learning sequence and apply each new concept to this same dataset.
3. Move on to exploring the 15 agroecological indicators as the learning sequence allows.

## Reproducible work

I have recorded the work in these R scripts:

- [`R/01_data_audit_cleaning.R`](R/01_data_audit_cleaning.R) — initial data audit and cleaning.
- [`R/02_numeric_relationship_review.R`](R/02_numeric_relationship_review.R) — numeric-variable profile and exploratory correlations.
- [`R/03_correlation_regression.R`](R/03_correlation_regression.R) — Pearson and Spearman correlations, Pearson sensitivity check, simple linear regression, and export of tables and a scatterplot.

The analysis findings are documented in [`reports/correlation-regression-analysis.md`](reports/correlation-regression-analysis.md). The initial data-quality findings are recorded in [`reports/initial-data-quality-audit.md`](reports/initial-data-quality-audit.md). The 19 November data-quality exercise and my missing-value decisions are documented in [my data-quality learning log](reports/missing-values-and-data-quality-learning-log.md).

The source dataset is not stored in this repository. I will only share it if its licence and access conditions permit redistribution. The R scripts expect me to load the authorised data locally and create the cleaned object `agro_clean`.

---

**My approach:** organise the project carefully, understand the data first, make cleaning decisions deliberately, and only then move to analysis.
