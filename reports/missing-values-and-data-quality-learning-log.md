# My data-quality learning log: standardising names and investigating missing values

**Date:** 19 November 2026  
**Dataset:** Viability of Agroecological Practices in Africa  
**Original dataset object:** `agro_data`  
**Cleaned working object:** `agro_clean`

## What I practised

In this Pro-RUWA lesson, I learned to assess data quality before interpreting statistical results. The lesson covered missing values, outliers, and how unusual observations can affect correlation and regression. I then applied the relevant data-cleaning and missing-value concepts to my agroecological practice adoption project.

The packages in the lesson workflow were:

- **`tidyverse`** — data inspection and manipulation with functions such as `select()`, `summarise()`, `mutate()`, `filter()`, `group_by()`, and `count()`.
- **`janitor`** — standardising variable names with `clean_names()`.
- **`naniar`** — introduced for missing-value summaries through functions such as `n_miss()` and `n_complete()`.
- **`readxl`** — importing Excel files with `read_excel()`.
- **`here`** — building project-relative file paths.
- **`broom`** — presenting statistical model results with functions such as `tidy()` and `glance()`.

For the project exercise, I directly applied `janitor::clean_names()`, tidyverse data-manipulation functions, and base R functions including `is.na()` and `rowSums()`. I used `sum(is.na())` to count missing values. The missing-value summaries in this exercise did not use `naniar`; that package was part of the lesson's toolkit.

## Standardising the variable names

I first previewed the proposed names with:

```r
janitor::make_clean_names(names(agro_data))
```

I then recreated my cleaned working dataset:

```r
agro_clean <- agro_data %>%
  janitor::clean_names() %>%
  select(where(~ !all(is.na(.x))))
```

The dataset remained at **98 observations and 28 variables**. The original dataset had 98 observations and 46 variables; the 18 entirely empty columns were removed from the working copy. The original `agro_data` was preserved.

The new names are lowercase and use underscores where appropriate. This makes them easier to use consistently in R code.

## What I found about missing values

I examined the livestock-related variables and compared missingness across farms.

The follow-up showed:

- `livestock_ubt` had **no missing values**.
- Each of the three livestock-management indicators — `x13farm_sgrazinglivestock_percent`, `x14farm_slivestockreceivingforages_percent`, and `x15farm_slivestocknourishedwithoutfeedatall_percent` — had **24 missing values**.
- Those three indicators were missing together for the same **24 farms**. The other **74 farms** had observed values for all three indicators.

When I compared the pattern with farm type and livestock holdings, I found that all 24 farms with the three missing indicator values belonged to **T1** and had **zero livestock UBT**. T2, T3, and T4 had no zero-livestock farms in this dataset, and their three indicator values were observed.

This is strong evidence that the three missing livestock-management indicators may be **structurally not applicable** for farms without livestock. I have not replaced these values with zero or deleted the 24 farms. I will retain them as missing and confirm the interpretation against the dataset documentation before making a final analytical decision.

### An important correction to the scope of this check

My earlier data audit had also flagged `cultivated_area_ha_livestock_ubt` as a fourth variable with 24 missing values. In this follow-up, I mistakenly selected `livestock_ubt` instead of that ratio variable when checking the overlap. Therefore, the results above establish the shared missingness pattern for the **three livestock-management indicators only**; they do not yet reconfirm the missingness pattern of `cultivated_area_ha_livestock_ubt`. I have kept this distinction explicit rather than treating the four-variable check as complete.

## The one missing permanent hired-worker value

I also investigated the single missing value in `permanenthiredworkersu`. It belongs to **Farm 16**, a T1 farm with 1.5 hectares cultivated, one family member, one family worker, and zero livestock UBT.

Although 22 of the 24 T1 farms reported zero permanent hired workers, that pattern is not enough to conclude that Farm 16 also had zero. This is a labour variable, and the missing value cannot be explained by the absence of livestock.

**My decision:** I will retain this value as `NA`. I will not replace it with zero or remove the farm without confirmation from the original records or dataset documentation.

## Decisions and lessons I am taking forward

1. I preserved the original dataset and carried out cleaning on `agro_clean`.
2. I standardised column names with `janitor::clean_names()` and removed only the 18 entirely empty columns.
3. I retained the 24 farms with missing livestock-management indicators. The evidence suggests these indicators may not apply to zero-livestock T1 farms, but I will confirm this interpretation from the documentation.
4. I retained Farm 16 and left its missing permanent hired-worker value as `NA`. I did not assume that missing means zero.
5. I did not impute missing values or delete observations during this exercise.

The main lesson for me is that **a missing value is not automatically a zero or a data error**. I need to understand what the variable measures and whether it applies to the observation before deciding how to handle it. I also learned to verify the exact variable names before writing code; using `livestock_ubt` instead of `cultivated_area_ha_livestock_ubt` changed the scope of my missingness check.

This is part of my learning journey: I am not only learning which R functions to use, but also how to question my results, recognise the limits of what I have established, and make transparent data-handling decisions.

## Next step

I will complete the one outstanding check on `cultivated_area_ha_livestock_ubt`, then continue with the next Pro-RUWA lesson and apply its concepts to this same dataset.
