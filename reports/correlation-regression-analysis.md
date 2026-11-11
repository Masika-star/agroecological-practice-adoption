# Agroecological Practice Adoption among Smallholder Farmers: Correlation and Simple Linear Regression

**Date:** 11 November 2026  
**Dataset object:** `agro_clean`  
**Analysis sample:** 98 farms  
**Outcome:** Proportion of cultivated area fertilised with organic manure  
**Explanatory variable:** Organic matter produced per cultivated hectare

## Purpose

I applied the correlation and simple linear regression techniques covered in the Pro-RUWA course to selected farm-level observations from the Viability of Agroecological Practices in Africa dataset. The practical exercise helped me distinguish linear association from rank-based monotonic association, interpret regression coefficients, and assess model fit.

## Variables selected

- **Organic matter production per cultivated hectare (X):** `4OMproduced(kgMS)/cultivatedarea(ha)`, measured in kgMS/ha.
- **Cultivated area fertilised with organic manure (Y):** `6Cultivatedareafertilizedwithorganicmanure(%)`, stored in the dataset on a 0–1 scale. The codebook should be consulted to confirm the fractional coding before translating values into percentages.

The analysis used 98 complete observations.

## Correlation results

| Method | Coefficient | p-value | Observations |
|---|---:|---:|---:|
| Pearson, all farms | -0.0423 | 0.6790 | 98 |
| Spearman, all farms | 0.2997 | 0.002718 | 98 |
| Pearson, excluding farm 23 (sensitivity check) | 0.2280 | 0.0249 | 97 |

Pearson correlation indicated a negligible negative linear association between the variables. The result was not statistically significant.

Spearman's rank correlation indicated a positive monotonic association (rho = 0.2997), statistically significant at the 1% level. This suggests that farms ranking higher in organic matter production also tended to rank higher in the proportion of cultivated land fertilised with organic manure.

The Pearson sensitivity check, which excluded farm 23 for that calculation only, produced a positive coefficient of 0.228 (p = 0.0249). The change from -0.0423 to 0.228 indicates that the Pearson result is sensitive to this observation. Farm 23 has not been deleted from the cleaned dataset or the main regression analysis.

## Simple linear regression

The estimated model was:

```
area_fertilized_pct ~ organic_matter_per_ha
```

### Coefficient estimates

| Term | Estimate | Standard error | p-value |
|---|---:|---:|---:|
| Intercept | 0.5570 | 0.0400 | 9.34e-25 |
| Organic matter production per ha | -0.00000884 | 0.0000213 | 0.6790 |

The estimated slope was negative and not statistically significant. A 1,000 kgMS/ha increase in organic matter production corresponds to an estimated 0.00884 reduction in the outcome proportion (approximately 0.884 percentage points if the 0–1 scale is confirmed as a fraction). The confidence interval for the slope included zero.

The intercept is the model's predicted outcome when organic matter production is zero. It is a fitted model value, not necessarily the observed mean among farms with zero production.

### Overall model fit

| Statistic | Result |
|---|---:|
| R-squared | 0.00179 |
| Adjusted R-squared | -0.00861 |
| Residual standard error | 0.363 |
| F-statistic | 0.172 |
| Model p-value | Approximately 0.679 |
| Observations | 98 |

The model explains approximately 0.179% of the observed variation in the outcome. Its overall F-test is not statistically significant. Organic matter production alone therefore provides very little linear explanatory power for the proportion of cultivated land fertilised with organic manure in this sample.

In simple linear regression with an intercept, the test of a zero slope is equivalent to the Pearson correlation test when both use the same observations. This explains why the Pearson and regression slope tests have the same p-value.

## Data-quality observation

The organic matter production variable had a maximum value of 16,000 kgMS/ha, substantially above its third quartile of 825 kgMS/ha. This observation belongs to farm 23 (farm type T1), which had 2 cultivated hectares and zero livestock units. There were 26 farms with zero organic matter production.

Farm 23 was retained in the main analysis. The sensitivity result excluding it was reported separately. No outlier treatment or deletion was performed in this exercise; the investigation and treatment of outliers are reserved for a separate learning topic.

## Learning points

1. Pearson correlation describes the direction and strength of a linear association.
2. Spearman correlation uses ranks and assesses monotonic association.
3. A correlation or regression p-value does not measure the practical importance of a relationship.
4. In simple linear regression, the slope represents the expected change in the outcome for a one-unit increase in the explanatory variable.
5. R-squared measures the share of observed outcome variation explained by the fitted model; adjusted R-squared accounts for model complexity.
6. Statistical association does not establish causation.

## Reproducible outputs

The analysis is reproduced by [`R/03_correlation_regression.R`](../R/03_correlation_regression.R).

When run in the R Project, the script saves the following in `out/`:

- `organic_matter_correlation_results.csv` — Pearson, Spearman and Pearson sensitivity results.
- `organic_matter_regression_coefficients.csv` — regression estimates and 95% confidence intervals.
- `organic_matter_regression_model_fit.csv` — R-squared, adjusted R-squared and other model-fit statistics.
- `organic_matter_scatterplot_regression.png` — scatterplot with fitted regression line.
- `organic_matter_analysis_results.xlsx` — a workbook containing the correlation, coefficient and model-fit tables on separate worksheets.

The source dataset is not included in the repository. The script expects the authorised dataset to be loaded locally and cleaned as `agro_clean`.
