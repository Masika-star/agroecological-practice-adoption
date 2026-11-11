# Correlation and simple linear regression
# Project: Agroecological Practice Adoption among Smallholder Farmers
# Dataset: Viability of Agroecological Practices in Africa dataset
#
# Purpose:
#   1. Reproduce Pearson and Spearman correlation tests.
#   2. Conduct a Pearson sensitivity check excluding farm 23.
#   3. Estimate a simple linear regression using all complete observations.
#   4. Export results tables to CSV and a multi-sheet Excel workbook.
#   5. Export the scatterplot with the fitted regression line.
#
# Main-analysis rule:
#   Farm 23 remains in the main correlation and regression analyses.
#   Excluding farm 23 is a separate sensitivity check only.
#
# Before running:
#   1. Open the R Project in RStudio.
#   2. Run R/01_data_audit_cleaning.R so agro_clean is available.
#   3. Run this script from the project root.
#
# Required packages:
#   tidyverse, broom, openxlsx, here

library(tidyverse)
library(broom)
library(openxlsx)
library(here)

# 1. Confirm the cleaned dataset is available -------------------------------

if (!exists("agro_clean")) {
  stop(
    "Object 'agro_clean' was not found. ",
    "Run R/01_data_audit_cleaning.R first."
  )
}

required_variables <- c(
  "Number",
  "4OMproduced(kgMS)/cultivatedarea(ha)",
  "6Cultivatedareafertilizedwithorganicmanure(%)"
)

missing_variables <- setdiff(required_variables, names(agro_clean))

if (length(missing_variables) > 0) {
  stop(
    "The following required variables are missing from agro_clean: ",
    paste(missing_variables, collapse = ", ")
  )
}

# 2. Prepare the analysis dataset -------------------------------------------

organic_matter_pair <- agro_clean |>
  transmute(
    Number,
    organic_matter_per_ha =
      `4OMproduced(kgMS)/cultivatedarea(ha)`,
    area_fertilized_pct =
      `6Cultivatedareafertilizedwithorganicmanure(%)`
  ) |>
  drop_na(
    organic_matter_per_ha,
    area_fertilized_pct
  )

message("Complete observations used in the main analysis: ",
        nrow(organic_matter_pair))

# 3. Pearson and Spearman correlation tests --------------------------------

pearson_test <- cor.test(
  organic_matter_pair$organic_matter_per_ha,
  organic_matter_pair$area_fertilized_pct,
  method = "pearson"
)

spearman_test <- cor.test(
  organic_matter_pair$organic_matter_per_ha,
  organic_matter_pair$area_fertilized_pct,
  method = "spearman",
  exact = FALSE
)

# 4. Pearson sensitivity check excluding farm 23 ----------------------------
# This is not the main analysis and does not delete farm 23 from agro_clean.

pearson_sensitivity_data <- organic_matter_pair |>
  filter(Number != 23)

pearson_sensitivity_test <- cor.test(
  pearson_sensitivity_data$organic_matter_per_ha,
  pearson_sensitivity_data$area_fertilized_pct,
  method = "pearson"
)

# Convert correlation test results into a consistent reporting table.
make_correlation_row <- function(test_result, method_name, n_used) {
  tidy_result <- broom::tidy(test_result)

  # Spearman's cor.test output does not provide the same confidence
  # interval fields as the Pearson test. Keep those cells as NA.
  if (!"conf.low" %in% names(tidy_result)) {
    tidy_result$conf.low <- NA_real_
  }

  if (!"conf.high" %in% names(tidy_result)) {
    tidy_result$conf.high <- NA_real_
  }

  tidy_result |>
    transmute(
      method = method_name,
      observations = n_used,
      coefficient = estimate,
      test_statistic = statistic,
      p_value = p.value,
      conf_low = conf.low,
      conf_high = conf.high
    )
}

correlation_results <- bind_rows(
  make_correlation_row(
    pearson_test,
    "Pearson (all complete observations)",
    nrow(organic_matter_pair)
  ),
  make_correlation_row(
    spearman_test,
    "Spearman (all complete observations)",
    nrow(organic_matter_pair)
  ),
  make_correlation_row(
    pearson_sensitivity_test,
    "Pearson (excluding farm 23; sensitivity check)",
    nrow(pearson_sensitivity_data)
  )
)

message("Correlation comparison:")
print(correlation_results)

# 5. Estimate simple linear regression using all complete observations ------

organic_matter_model <- lm(
  area_fertilized_pct ~ organic_matter_per_ha,
  data = organic_matter_pair
)

# Coefficient table, including 95% confidence intervals.
regression_coefficients <- broom::tidy(
  organic_matter_model,
  conf.int = TRUE,
  conf.level = 0.95
)

message("Regression coefficients:")
print(regression_coefficients)

# Overall model-fit statistics, including R-squared and adjusted R-squared.
model_performance <- broom::glance(organic_matter_model) |>
  select(
    r.squared,
    adj.r.squared,
    sigma,
    statistic,
    p.value,
    df,
    df.residual,
    nobs,
    AIC,
    BIC
  ) |>
  rename(
    r_squared = r.squared,
    adjusted_r_squared = adj.r.squared,
    residual_standard_error = sigma,
    f_statistic = statistic,
    model_p_value = p.value,
    model_df = df,
    residual_df = df.residual,
    observations = nobs
  )

message("Overall model performance:")
print(model_performance)

# Fitted values and residuals are retained in R for inspection.
regression_observations <- broom::augment(organic_matter_model)

# 6. Create the scatterplot -------------------------------------------------
# The outcome is stored between 0 and 1. The y-axis is labelled as a
# percentage for readability; the underlying model still uses proportions.

organic_matter_scatterplot <- ggplot(
  organic_matter_pair,
  aes(
    x = organic_matter_per_ha,
    y = area_fertilized_pct
  )
) +
  geom_point(alpha = 0.75, size = 2) +
  geom_smooth(
    method = "lm",
    formula = y ~ x,
    se = TRUE
  ) +
  scale_x_continuous(
    labels = scales::label_comma()
  ) +
  scale_y_continuous(
    labels = scales::label_percent(accuracy = 1),
    limits = c(0, 1)
  ) +
  labs(
    title = "Organic Matter Production and Organic Manure Application",
    subtitle = "Viability of Agroecological Practices in Africa dataset: all complete observations included",
    x = "Organic matter produced per cultivated hectare (kgMS/ha)",
    y = "Cultivated area fertilised with organic manure (%)",
    caption = paste(
      "The fitted line is from a simple linear regression.",
      "Farm 23 is retained in the main analysis."
    )
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  )

print(organic_matter_scatterplot)

# 7. Create output directory and export CSV files ---------------------------

out_dir <- here::here("out")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

readr::write_csv(
  correlation_results,
  file.path(out_dir, "organic_matter_correlation_results.csv")
)

readr::write_csv(
  regression_coefficients,
  file.path(out_dir, "organic_matter_regression_coefficients.csv")
)

readr::write_csv(
  model_performance,
  file.path(out_dir, "organic_matter_regression_model_fit.csv")
)

# 8. Export the scatterplot as a high-resolution PNG ------------------------

ggplot2::ggsave(
  filename = file.path(
    out_dir,
    "organic_matter_scatterplot_regression.png"
  ),
  plot = organic_matter_scatterplot,
  width = 9,
  height = 6,
  dpi = 300,
  bg = "white"
)

# 9. Export all reporting tables to one Excel workbook ----------------------

results_workbook <- openxlsx::createWorkbook()

openxlsx::addWorksheet(results_workbook, "Correlation results")
openxlsx::addWorksheet(results_workbook, "Regression coefficients")
openxlsx::addWorksheet(results_workbook, "Model fit")

openxlsx::writeDataTable(
  results_workbook,
  sheet = "Correlation results",
  x = correlation_results,
  tableStyle = "TableStyleMedium2"
)

openxlsx::writeDataTable(
  results_workbook,
  sheet = "Regression coefficients",
  x = regression_coefficients,
  tableStyle = "TableStyleMedium2"
)

openxlsx::writeDataTable(
  results_workbook,
  sheet = "Model fit",
  x = model_performance,
  tableStyle = "TableStyleMedium2"
)

openxlsx::freezePane(results_workbook, "Correlation results", firstRow = TRUE)
openxlsx::freezePane(results_workbook, "Regression coefficients", firstRow = TRUE)
openxlsx::freezePane(results_workbook, "Model fit", firstRow = TRUE)

openxlsx::setColWidths(
  results_workbook,
  "Correlation results",
  cols = 1:ncol(correlation_results),
  widths = "auto"
)

openxlsx::setColWidths(
  results_workbook,
  "Regression coefficients",
  cols = 1:ncol(regression_coefficients),
  widths = "auto"
)

openxlsx::setColWidths(
  results_workbook,
  "Model fit",
  cols = 1:ncol(model_performance),
  widths = "auto"
)

openxlsx::saveWorkbook(
  results_workbook,
  file = file.path(out_dir, "organic_matter_analysis_results.xlsx"),
  overwrite = TRUE
)

# 10. Confirm exported files ------------------------------------------------

message("Analysis completed. The following files were saved in: ", out_dir)
message("- organic_matter_correlation_results.csv")
message("- organic_matter_regression_coefficients.csv")
message("- organic_matter_regression_model_fit.csv")
message("- organic_matter_scatterplot_regression.png")
message("- organic_matter_analysis_results.xlsx")

# Interpretation reminders:
# - Pearson estimates linear association; Spearman estimates monotonic
#   rank association.
# - Farm 23 is retained in the main analysis. Its exclusion appears only in
#   the separate Pearson sensitivity row.
# - The regression uses all complete observations.
# - The outcome is stored between 0 and 1; check the codebook to confirm
#   the variable's fractional interpretation before reporting percentages.
# - Statistical association does not establish causation.
