# Initial data exploration and quality audit

**Project:** Agroecological Practice Adoption among Smallholder Farmers: An Exploratory Analysis in R  
**Audit date:** 31 October 2026  
**Dataset object in R:** `agro_dat`  
**Working copy:** `agro_clean`

## 1. Scope and reproducibility

The dataset was explored in R using the tidyverse, particularly `dplyr` and `tidyr`. The source object was retained as `agro_dat`; a separate working object, `agro_clean`, was created for initial cleaning.

The original dataset file, source citation, licence, codebook, and geographic/sample documentation have not yet been recorded in this repository. These details must be confirmed before substantive interpretation or redistribution. The raw dataset has therefore not been committed to GitHub.

The reproducible workflow is recorded in [`R/01_data_audit_cleaning.R`](../R/01_data_audit_cleaning.R).

## 2. Dataset dimensions

| Check | Result |
|---|---:|
| Original observations | 98 |
| Original variables | 46 |
| Completely empty columns identified | 18 |
| Retained observations | 98 |
| Retained variables | 28 |

The 18 completely empty columns were labelled `AC` through `AT` in the imported dataset. They were removed from the working copy using:

```r
agro_clean <- agro_dat |>
  select(where(~ !all(is.na(.x))))
```

This retained all 98 observations and reduced the working dataset from 46 to 28 variables. The original `agro_dat` object was not overwritten.

## 3. Duplicate checks

| Check | Result |
|---|---:|
| Completely duplicated rows | 0 |
| Repeated values of observation identifier `Number` | 0 |

No exact duplicate rows or repeated observation identifiers were detected in the 98-row working dataset.

## 4. Classification variables

### Farm types

| Farm type | Observations | Percentage |
|---|---:|---:|
| T1 | 24 | 24.49% |
| T2 | 25 | 25.51% |
| T3 | 24 | 24.49% |
| T4 | 25 | 25.51% |
| **Total** | **98** | **100.00%** |

The four farm types are nearly equally represented. The meaning and classification criteria for T1–T4 still need to be documented from the dataset source or codebook.

### Structural-data category

All 98 observations were classified as `Structural data`. This variable has only one observed category in the current dataset and therefore does not distinguish between observations. Its intended meaning should be confirmed before it is considered for analysis.

## 5. Missing-value assessment

Missingness was assessed using R's `is.na()` definition. Five variables had at least one missing observation; the other 23 retained variables had none.

| Variable | Missing observations | Missing percentage |
|---|---:|---:|
| `Cultivated.area.ha..Livestock.UBT.` | 24 | 24.49% |
| `X13Farm.sgrazinglivestock...` | 24 | 24.49% |
| `X14Farm.slivestockreceivingforages...` | 24 | 24.49% |
| `X15Farm.slivestocknourishedwithoutfeedatall...` | 24 | 24.49% |
| `Permanenthiredworkersu` | 1 | 1.02% |
| **Other 23 variables** | **0 each** | **0.00% each** |

The four variables with 24 missing observations are livestock-related. Their equal missing counts do **not** yet establish that the missing values occur in the same 24 records or that the values are structurally missing. The missingness pattern and the relationship with `LivestockUBT` must be checked.

The single missing value in `Permanenthiredworkersu` also requires review against the original questionnaire or source data.

## 6. Cleaning decisions made so far

1. Removed only columns that were entirely missing.
2. Preserved all 98 observations.
3. Preserved the original imported object `agro_dat`.
4. Created `agro_clean` as the working dataset.
5. Did not impute missing values, replace missing values with zero, or delete records.

These decisions avoid treating an unrecorded value as a genuine zero, particularly for livestock ownership and management variables.

## 7. Outstanding checks

The next data-quality tasks are:

- Determine whether the four variables with 24 missing values share the same missing-record pattern.
- Compare those records with `LivestockUBT` and the farm-type classifications.
- Establish whether the missing livestock measurements are not applicable, unrecorded, or caused by another skip pattern.
- Investigate the single missing value in `Permanenthiredworkersu`.
- Confirm the definitions, units, valid ranges, and coding of all 28 retained variables from the codebook.
- Check for implausible values and internal inconsistencies before descriptive analysis.
- Record the dataset source, citation, access conditions, and sampling information.

**No imputation, case deletion, or substantive modelling has been undertaken at this stage.**
