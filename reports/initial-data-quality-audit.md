# My first data exploration: what I found

**Date:** 31 October 2026  
**Dataset object:** `agro_dat`  
**Working copy:** `agro_clean`

## Starting point

I began by exploring the dataset in R using the tidyverse. The first inspection showed **98 observations and 46 variables**.

I noticed that the last 18 columns, labelled `AC` to `AT`, were completely empty. I used:

```r
agro_clean <- agro_dat |>
  select(where(~ !all(is.na(.x))))
```

This created a working copy with **98 observations and 28 variables**. I kept the original `agro_dat` unchanged.

## What I discovered

**Farm types:** The 98 farms are almost evenly distributed across four types: T1 = 24, T2 = 25, T3 = 24, and T4 = 25. I still need to find the definitions of T1–T4.

**Structural data:** All 98 observations have the value `Structural data`. At this stage, this variable does not distinguish between farms, and I need to establish why it is included.

**Duplicates:** I found no completely duplicated rows and no repeated observation numbers.

**Missing values:** Five variables contain missing values:

| Variable | Missing | Percentage |
|---|---:|---:|
| `Cultivated.area.ha..Livestock.UBT.` | 24 | 24.49% |
| `X13Farm.sgrazinglivestock...` | 24 | 24.49% |
| `X14Farm.slivestockreceivingforages...` | 24 | 24.49% |
| `X15Farm.slivestocknourishedwithoutfeedatall...` | 24 | 24.49% |
| `Permanenthiredworkersu` | 1 | 1.02% |

The remaining 23 variables have no missing values.

## What I learned

I practised using `count()` to examine categories, `summarise()` and `across()` to calculate missing values, and `pivot_longer()` to turn the missing-value summary into an easier-to-read table.

I also learned to preserve the original dataset and make changes to a working copy. Most importantly, I should not automatically replace missing values with zero: a farm with no livestock is not the same as a farm whose livestock information was not recorded.

## My next questions

The four livestock-related variables have the same number of missing values, but I have not yet confirmed whether they are missing for the same 24 farms. I want to compare them with `LivestockUBT` and farm type to understand the pattern.

I also need to investigate the single missing value in `Permanenthiredworkersu` and check variable definitions and units against the source documentation.

For now, **I have not deleted any observations or imputed any missing values**. My next step is to understand these missing records before moving on to the 15 agroecological indicators.

## Code

I recorded the workflow in [`R/01_data_audit_cleaning.R`](../R/01_data_audit_cleaning.R). The script expects the authorised dataset to be loaded locally as `agro_dat`; the raw data have not been uploaded to GitHub.
