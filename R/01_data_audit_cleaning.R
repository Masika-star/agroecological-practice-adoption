# Initial data audit and cleaning
# Project: Agroecological Practice Adoption among Smallholder Farmers
# Purpose: Inspect the imported dataset and create a working copy without
#           deleting observations or imputing missing values.
#
# Before running:
#   1. Open the project in RStudio.
#   2. Import the authorised source dataset into an object named `agro_dat`.
#   3. Run this script from the project root.
#
# The source data are intentionally not stored in this repository.

library(tidyverse)

if (!exists("agro_dat")) {
  stop(
    "Object 'agro_dat' was not found. Import the authorised source dataset ",
    "into R as agro_dat, then run this script again."
  )
}

# 1. Inspect the original dataset -----------------------------------------

original_dimensions <- dim(agro_dat)
original_variable_names <- names(agro_dat)

message(
  "Original dataset: ",
  original_dimensions[1], " observations and ",
  original_dimensions[2], " variables."
)

glimpse(agro_dat)

# 2. Identify and remove columns that are entirely missing ----------------

empty_columns <- names(agro_dat)[
  vapply(agro_dat, function(x) all(is.na(x)), logical(1))
]

message(
  "Completely empty columns identified: ",
  if (length(empty_columns) == 0) "none" else paste(empty_columns, collapse = ", ")
)

# Keep the original object unchanged and create a cleaned working copy.
agro_clean <- agro_dat |>
  select(where(~ !all(is.na(.x))))

clean_dimensions <- dim(agro_clean)

stopifnot(nrow(agro_clean) == nrow(agro_dat))

message(
  "Working dataset after removing completely empty columns: ",
  clean_dimensions[1], " observations and ",
  clean_dimensions[2], " variables."
)

# 3. Check completely duplicated rows ------------------------------------

n_exact_duplicates <- sum(duplicated(agro_clean))
message("Completely duplicated rows: ", n_exact_duplicates)

# 4. Check duplicated observation identifiers ----------------------------

if ("Number" %in% names(agro_clean)) {
  duplicate_number_ids <- agro_clean |>
    count(Number) |>
    filter(n > 1)

  message("Repeated observation identifiers:")
  print(duplicate_number_ids)
} else {
  warning("The expected identifier variable 'Number' was not found.")
}

# 5. Summarise missing values across all retained variables ---------------

missing_report <- agro_clean |>
  summarise(
    across(everything(), ~ sum(is.na(.x)))
  ) |>
  pivot_longer(
    cols = everything(),
    names_to = "Variable",
    values_to = "Missing"
  ) |>
  mutate(
    Percentage = round(Missing / nrow(agro_clean) * 100, 2)
  ) |>
  arrange(desc(Missing), Variable)

message("Missing-value report:")
print(missing_report, n = Inf)

# 6. Explore the main classification variables ----------------------------

if ("Farmtypes" %in% names(agro_clean)) {
  farmtype_summary <- agro_clean |>
    count(Farmtypes, name = "n") |>
    mutate(Percentage = round(n / sum(n) * 100, 2))

  message("Farm-type distribution:")
  print(farmtype_summary)
}

if ("Structuraldata" %in% names(agro_clean)) {
  structuraldata_summary <- agro_clean |>
    count(Structuraldata, name = "n")

  message("Structural-data distribution:")
  print(structuraldata_summary)
}

# 7. Review variable classes ------------------------------------------------

message("Variable structure of the cleaned working dataset:")
glimpse(agro_clean)

# Notes:
# - agro_dat is preserved; agro_clean is the working copy.
# - No observations have been removed.
# - No partial missing values have been imputed or replaced with zero.
# - Investigate the reason for missing livestock-related measurements
#   before deciding how to handle them.
# - Confirm the dataset source, codebook, licence, and variable definitions
#   before substantive interpretation or modelling.
