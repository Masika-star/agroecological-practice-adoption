# Numeric variable review and exploratory correlations
# Project: Agroecological Practice Adoption among Smallholder Farmers
# Purpose:
#   1. Profile numeric variables before selecting relationships to analyse.
#   2. Identify variables with sufficient observed variation.
#   3. Produce an exploratory Pearson correlation matrix and heatmap.
#
# Important:
#   - This script does not assume the dataset contains fertilizer or yield data.
#   - Check variable definitions and units before interpreting any relationship.
#   - Numeric codes, ordinal scales, and identifiers should not automatically
#     be treated as continuous measurements.
#   - Correlation describes linear association; it does not establish causation.
#
# Before running:
#   1. Open the R Project in RStudio.
#   2. Import the authorised source dataset as agro_dat.
#   3. Run R/01_data_audit_cleaning.R first, or let this script create agro_clean.
#   4. Run this script from the project root.

library(tidyverse)

# 1. Confirm that the working dataset is available -------------------------

if (!exists("agro_clean")) {
  if (exists("agro_dat")) {
    agro_clean <- agro_dat |>
      select(where(~ !all(is.na(.x))))
  } else {
    stop(
      "Neither 'agro_clean' nor 'agro_dat' was found. ",
      "Import the authorised dataset as agro_dat and run the data-audit script."
    )
  }
}

# 2. Prepare the output directory -------------------------------------------

out_dir <- here::here("out")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# 3. Identify and profile numeric variables --------------------------------

numeric_data <- agro_clean |>
  select(where(is.numeric))

if (ncol(numeric_data) == 0) {
  stop("No numeric variables were found in agro_clean.")
}

numeric_profile <- purrr::map_dfr(
  names(numeric_data),
  function(variable_name) {
    x <- numeric_data[[variable_name]]
    observed_x <- x[!is.na(x)]

    tibble(
      variable = variable_name,
      n_observed = length(observed_x),
      n_missing = sum(is.na(x)),
      missing_percent = round(mean(is.na(x)) * 100, 2),
      n_unique = n_distinct(observed_x),
      mean = if (length(observed_x) > 0) mean(observed_x) else NA_real_,
      sd = if (length(observed_x) > 1) sd(observed_x) else NA_real_,
      minimum = if (length(observed_x) > 0) min(observed_x) else NA_real_,
      median = if (length(observed_x) > 0) median(observed_x) else NA_real_,
      maximum = if (length(observed_x) > 0) max(observed_x) else NA_real_
    )
  }
) |>
  arrange(desc(n_unique), variable)

message("Numeric-variable profile:")
print(numeric_profile, n = Inf)

readr::write_csv(
  numeric_profile,
  file.path(out_dir, "numeric_variable_profile.csv")
)

# 4. Select preliminary continuous-variable candidates ---------------------
#
# Exclude identifiers and any numeric codes or ordinal variables that should
# not be treated as continuous. Add their exact column names below after
# checking the codebook.

exclude_from_correlation <- c(
  "Number"
  # Add other identifiers, numeric category codes, or ordinal variables here.
)

correlation_variables <- numeric_profile |>
  filter(
    n_unique > 2,
    !tolower(variable) %in% tolower(exclude_from_correlation)
  ) |>
  pull(variable)

message(
  "Variables provisionally eligible for Pearson correlation: ",
  if (length(correlation_variables) == 0) {
    "none"
  } else {
    paste(correlation_variables, collapse = ", ")
  }
)

# 5. Estimate exploratory pairwise Pearson correlations -------------------

if (length(correlation_variables) >= 2) {
  correlation_data <- agro_clean |>
    select(all_of(correlation_variables))

  correlation_matrix <- cor(
    correlation_data,
    use = "pairwise.complete.obs",
    method = "pearson"
  )

  correlation_output <- as.data.frame(correlation_matrix) |>
    tibble::rownames_to_column(var = "variable")

  readr::write_csv(
    correlation_output,
    file.path(out_dir, "pearson_correlation_matrix.csv")
  )

  # Record the number of observations contributing to each variable pair.
  pair_sample_sizes <- tidyr::expand_grid(
    variable_1 = correlation_variables,
    variable_2 = correlation_variables
  ) |>
    rowwise() |>
    mutate(
      n_pairwise = sum(
        complete.cases(
          agro_clean[[variable_1]],
          agro_clean[[variable_2]]
        )
      )
    ) |>
    ungroup()

  correlation_long <- as.data.frame(as.table(correlation_matrix)) |>
    as_tibble() |>
    rename(
      variable_1 = Var1,
      variable_2 = Var2,
      pearson_r = Freq
    ) |>
    left_join(pair_sample_sizes, by = c("variable_1", "variable_2"))

  readr::write_csv(
    correlation_long,
    file.path(out_dir, "pearson_correlations_long.csv")
  )

  # Visualise the correlation matrix.
  correlation_plot <- ggplot(
    correlation_long,
    aes(x = variable_1, y = variable_2, fill = pearson_r)
  ) +
    geom_tile(colour = "white") +
    geom_text(aes(label = ifelse(is.na(pearson_r), "NA",
                                 sprintf("%.2f", pearson_r))),
              size = 3) +
    coord_equal() +
    scale_fill_gradient2(
      low = "#B2182B",
      mid = "white",
      high = "#2166AC",
      midpoint = 0,
      limits = c(-1, 1),
      na.value = "grey85"
    ) +
    labs(
      title = "Exploratory Pearson correlation matrix",
      subtitle = "Numeric variables with more than two observed values",
      x = NULL,
      y = NULL,
      fill = "Pearson's r",
      caption = paste(
        "Pairwise complete observations are used.",
        "Check variable definitions, units, outliers and sample sizes before interpretation."
      )
    ) +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      panel.grid = element_blank()
    )

  plot_height <- max(6, length(correlation_variables) * 0.45)

  ggsave(
    filename = file.path(out_dir, "pearson_correlation_heatmap.png"),
    plot = correlation_plot,
    width = 9,
    height = plot_height,
    dpi = 300
  )

  print(correlation_plot)

} else {
  message(
    "At least two eligible numeric variables are needed for a correlation matrix. ",
    "Review the variable profile and exclusions."
  )
}

# 6. Interpretation reminders ----------------------------------------------
#
# - Pearson's r ranges from -1 to +1 and describes the direction and strength
#   of a linear relationship.
# - A correlation near zero does not rule out a nonlinear relationship.
# - A large correlation does not establish that one variable causes another.
# - Pairwise sample sizes may differ because of missing observations.
# - Statistical significance is not the same as practical importance.
# - Select a regression pair only after checking the codebook, measurement
#   units, scatterplot, missingness, outliers and substantive plausibility.
# - For simple linear regression, lm(y ~ x, data = ...) estimates the
#   expected change in y associated with a one-unit increase in x.
# - Do not remove the intercept unless the research design and substantive
#   theory justify forcing the fitted line through the origin.

message("Numeric-variable review completed. Check the files saved in: ", out_dir)
