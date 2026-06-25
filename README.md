<div align="center">

# Northern Star — DeKalb Car Crash Analysis

**Scraping and analyzing DeKalb-area traffic crash data for a data-journalism story.**

![Python](https://img.shields.io/badge/Python-3.x-3776AB?style=flat&logo=python&logoColor=white)
![R](https://img.shields.io/badge/R-276DC3?style=flat&logo=r&logoColor=white)
![pandas](https://img.shields.io/badge/pandas-150458?style=flat&logo=pandas&logoColor=white)
![tidyverse](https://img.shields.io/badge/tidyverse-1A162D?style=flat&logo=tidyverse&logoColor=white)
![PyPDF2](https://img.shields.io/badge/PyPDF2-PDF%20parsing-5A5A5A?style=flat)
![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)

</div>

## Overview

This repository holds the data-extraction and analysis code behind a *Northern Star* data-journalism story on traffic crashes in the DeKalb, Illinois area. A Python pipeline parses a 2013 DeKalb crash report distributed as a PDF, pulling tabular crash figures out of the raw text. An R script then reshapes those figures alongside state crash exports — crashes by age and sex of operator, and crashes by time of day — into clean summary tables ready for charting. The result is a set of tidy CSVs that group crashes by age band, gender, and time-of-day window.

## Features

- Extracts text and tabular data from the `DeKalb 2013.pdf` crash report using PyPDF2.
- Segments the extracted text on section keywords (e.g. `WEATHER`, `TOTALS`, `TYPE`) to isolate crash tables.
- Parses crash records into structured rows using regular-expression and index-based slicing.
- Reshapes crash counts in R: bins operators into age groups, splits totals by gender, and buckets crashes into time-of-day windows.
- Produces analysis-ready CSV outputs (by age, by gender, by time of day) for downstream reporting and visualization.

## Tech stack

- **Python 3** — PDF parsing and record extraction
  - **PyPDF2** — read and extract text from the PDF report
  - **pandas** / **NumPy** — data handling
  - **re** — pattern-based parsing of crash rows
- **R** — data wrangling and summary tables
  - **tidyverse** (dplyr, tidyr) — grouping, slicing, reshaping
  - **readr** / **readxl** — read CSV and Excel inputs

## How it works

1. **Read the PDF** — `carcrashreader.py` opens `DeKalb 2013.pdf`, extracts the text of every page, flattens it into a token list, and slices it at known section keywords to isolate the crash tables.
2. **Process the records** — `carcrashprocessing.py` (`ProcessGrades`) cleans the token list, strips commas, and uses regular expressions and index logic to slice the stream into individual crash-record lines.
3. **Analyze in R** — `NIUcarcrashes.R` loads state crash exports (crashes by age/sex of operator and by time of day) plus the parsed 2013 figures, then:
   - bins operators into age groups (`0–17`, `18–24`, `25+`) and sums counts,
   - splits totals into male/female,
   - buckets crashes into time-of-day windows, and
   - writes the summary tables to CSV (`age_frame.csv`, `gender_frame.csv`, `crashes_bytime.csv`, `crashesbyAge_2013.csv`).

## Getting started

### Prerequisites

- Python 3 with `PyPDF2`, `pandas`, and `numpy`
- R with the `tidyverse`, `readr`, and `readxl` packages

### Run the PDF extraction

```bash
pip install PyPDF2 pandas numpy
python carcrashreader.py
```

`carcrashreader.py` reads `DeKalb 2013.pdf` (the default input) and runs it through the processing class to slice out crash records.

### Run the R analysis

```r
# from R / RStudio
source("NIUcarcrashes.R")
```

> **Note:** `NIUcarcrashes.R` reads source CSV/Excel files from local paths (e.g. `~/Downloads`, OneDrive). Update the `read_csv()` / `read_excel()` paths near the top of the script to point at your own copies of the state crash exports before running. The script writes its output CSVs to the working directory.

## Author

**Devin Oommen** — [devinoommen.com](https://devinoommen.com) · Oommen & Company

## License

Released under the [MIT License](LICENSE).
