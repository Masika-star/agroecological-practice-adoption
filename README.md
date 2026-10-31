# Agroecological Practice Adoption among Smallholder Farmers: An Exploratory Analysis in R

## Project status

**Status:** Initial data exploration and quality assessment in progress  
**Primary tool:** R / RStudio  
**Learning context:** Pro-RUWA — *R-Statistics for Beginners*  
**Research question:** To be refined after documenting the dataset and reviewing its codebook.

## 1. Project overview

This project uses R to explore how smallholder farmers adopt agroecological practices, both individually and in combination. It is a learning-oriented, reproducible agricultural research project designed to strengthen skills in data management, exploratory analysis, statistical reasoning, visualisation, and transparent reporting.

The project is related to my wider research interests in agroecology and smallholder farming, but it is being developed as a distinct analysis using a dataset separate from my MSc study data.

## 2. Research question

The final research question will be written after the dataset source, documentation, variables, and study population have been verified.

**Initial working question (not final):**

> What patterns of individual and joint adoption of agroecological practices can be identified among smallholder farmers in the selected dataset?

The final question must be specific enough to answer with the chosen variables and study population. It will not be finalised until the data source, indicators, geographic coverage, and limitations have been checked.

## 3. Project objectives

The initial learning objectives are to:

1. Identify and document suitable agroecological-practice indicators in the dataset.
2. Clean and validate the data using a transparent R workflow.
3. Describe the prevalence of individual practices and explore which practices tend to occur together.
4. Produce clear, interpretable tables and visualisations.
5. Apply an appropriate introductory statistical analysis where supported by the research question and data.
6. Document analytical decisions, limitations, and lessons learned in a reproducible report.

These objectives may be refined when the research question and data source are confirmed.

## 4. Data source and selection criteria

**Dataset under exploration:** The data are currently loaded in R as an object named `agro_dat`. The initial inspection identified 98 observations and 46 imported variables. After removing 18 completely empty columns from a separate working copy, the dataset contains 98 observations and 28 retained variables.

The original dataset title, publisher, citation, access link, licence, geographic coverage, collection period, and codebook have not yet been documented in this repository. These details must be verified before substantive interpretation or redistribution.

Before analysis, record:

- Dataset title, publisher, citation, and access link.
- Study locations, target population, sample size, and data-collection period (where documented).
- Definitions, units, and coding of each practice indicator.
- Missing-data patterns and any survey weights or sampling design information.
- Data-use, confidentiality, and redistribution restrictions.

Raw data will not be committed to this repository unless the data licence and terms explicitly permit redistribution. The current working dataset has not been uploaded to GitHub.

## 5. Planned analytical workflow

The analysis will proceed in stages rather than assuming a model before examining the data.

1. **Data documentation:** read the codebook and map relevant variables to the research question.
2. **Import and validation:** import the authorised data, inspect variable types and values, and check identifiers, duplicates, missingness, and coding errors.
3. **Data preparation:** document decisions and create analysis-ready practice indicators where justified by the questionnaire and codebook.
4. **Descriptive analysis:** summarise adoption of each practice using appropriate denominators and, where required, account for the sampling design.
5. **Co-adoption exploration:** visualise combinations of practices and describe common patterns without treating simple co-occurrence as proof of a causal relationship.
6. **Additional analysis:** consider suitable tests or regression only after confirming the outcome, explanatory variables, assumptions, and data structure.
7. **Reporting:** present results, uncertainty where appropriate, limitations, and reproducible code.

Latent class analysis may be considered at a later stage if the dataset contains enough suitable categorical indicators and the method is justified by the research question. It is not a predetermined requirement for completing this introductory project.

## 6. Initial data exploration and quality checks

The first audit was completed on 31 October 2026. The detailed record is in [`reports/initial-data-quality-audit.md`](reports/initial-data-quality-audit.md).

| Item | Finding |
|---|---|
| Original dataset dimensions | 98 observations × 46 variables |
| Completely empty columns | 18 identified and removed from the working copy |
| Working dataset dimensions | 98 observations × 28 variables |
| Completely duplicated rows | 0 |
| Repeated observation identifiers (`Number`) | 0 |
| Farm-type distribution | T1: 24; T2: 25; T3: 24; T4: 25 |
| Structural-data category | All 98 observations have the value `Structural data` |
| Variables with any missing values | 5 of 28 |

The 18 empty columns were labelled `AC` through `AT`. The four livestock-related variables below each contain 24 missing values (24.49%): `Cultivated.area.ha..Livestock.UBT.`, `X13Farm.sgrazinglivestock...`, `X14Farm.slivestockreceivingforages...`, and `X15Farm.slivestocknourishedwithoutfeedatall...`. `Permanenthiredworkersu` contains one missing value (1.02%); the other 23 variables contain no missing values.

The four livestock-related variables have equal missing counts, but it has not yet been established whether the same records are missing across all four variables or why the values are missing. No observations have been deleted and no missing values have been imputed or replaced with zero.

The reusable audit workflow is in [`R/01_data_audit_cleaning.R`](R/01_data_audit_cleaning.R). It expects the authorised source data to be imported locally as `agro_dat`.

## 7. Planned repository structure

```text
agroecological-practice-adoption/
├── README.md
├── .gitignore
├── data/
│   └── README.md
├── R/
│   ├── README.md
│   └── 01_data_audit_cleaning.R
├── outputs/
│   └── README.md
└── reports/
    ├── README.md
    └── initial-data-quality-audit.md
```

This structure may evolve as the project develops. The repository keeps raw inputs separate from scripts, derived outputs, and written interpretation.

## 8. Project checklist

### Milestone 1 — Define the question

- [ ] Complete the Pro-RUWA course introduction module.
- [ ] Review the course learning outcomes and note the R skills covered.
- [ ] Write one clear, answerable research question.
- [ ] Define the target population, unit of analysis, and key concepts.

### Milestone 2 — Select and understand the data

- [ ] Verify the dataset source, citation, access conditions, and licence.
- [ ] Obtain and review the dataset documentation and codebook.
- [ ] Confirm the relevant practice indicators and their definitions.
- [ ] Record the data citation, access conditions, licence, and limitations.

### Milestone 3 — Import and prepare the data

- [x] Inspect the imported dataset structure and dimensions.
- [x] Identify and remove completely empty columns from a working copy.
- [x] Check for completely duplicated rows and repeated observation identifiers.
- [x] Produce an initial variable-level missing-data summary.
- [ ] Investigate the causes and record-level pattern of missing livestock measurements.
- [ ] Check variable coding, valid ranges, units, and internal consistency.
- [ ] Document all final data-preparation decisions.

### Milestone 4 — Explore and analyse

- [ ] Calculate adoption summaries for the selected practices.
- [ ] Produce at least two useful and clearly labelled visualisations.
- [ ] Explore co-adoption patterns.
- [ ] Add an appropriate statistical test or model only if justified.
- [ ] Interpret results in plain language and state key limitations.

### Milestone 5 — Make the work reproducible

- [ ] Ensure scripts run from a clean session with documented prerequisites.
- [ ] Add data-access instructions without sharing unauthorised data.
- [ ] Write a concise report describing methods and findings.
- [ ] Review the README and repository structure.
- [ ] Commit the completed work and record what I learned.

## 9. Tools and learning approach

The initial workflow uses R and RStudio. The tidyverse is being used for data inspection and manipulation, including `dplyr` and `tidyr`. Packages will be selected as needed and documented in the project scripts or environment files. Priority is given to understanding the purpose of each analysis, why a method is appropriate, its assumptions, and how to interpret the results—not simply obtaining output from R commands.

## 10. Expected outputs

By the end of the initial project, I aim to produce:

- A documented and reproducible R workflow.
- A data-quality summary.
- A practice-adoption summary table.
- Clear figures showing practice prevalence and co-adoption patterns.
- A short analytical report with findings, limitations, and references.

## 11. Limitations and responsible interpretation

This project will be exploratory. Results will describe the selected dataset and will not automatically generalise to all Kenyan smallholder farmers. Cross-sectional associations and co-adoption patterns will not be interpreted as causal effects. Conclusions will reflect the data's sampling design, measurement quality, geographic scope, and other documented limitations.

## 12. Author

**Masika-star**  
Agricultural economics | Agroecology | Applied statistics | Reproducible agricultural research

---

*Project note: The research question, dataset provenance, variable definitions, and final analysis remain subject to verification. The initial data audit is a record of data exploration, not a completed substantive analysis.*
