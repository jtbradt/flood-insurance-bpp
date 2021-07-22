# Comparing the effects of behaviorally informed interventions on flood insurance demand: an experimental analysis of 'boosts' and 'nudges'

This repository contains data and *R* code to reproduce Bradt (2019), "[Comparing the effects of behaviorally informed interventions on flood insurance demand: an experimental analysis of 'boosts' and 'nudges'](https://doi.org/10.1017/bpp.2019.31)."

> **Abstract:** This paper compares the effects of two types of behaviorally informed policy – nudges and boosts – that are designed to increase consumer demand for insurance against low-probability, high-consequence events. Using previous findings in the behavioral sciences literature, this paper constructs and implements two nudges (an ‘informational’ and an ‘affective’ nudge) and a statistical numeracy boost and then elicits individual risk beliefs and demand for flood insurance using a contingent valuation survey of 331 participants recruited from an online labor pool. Using a two-limit Tobit model to estimate willingness to pay (WTP) for flood insurance, this paper finds that the affective and informational nudges result in increases in WTP for flood insurance of roughly $21/month and $11/month relative to the boost, respectively. Taken together, the findings of this paper suggest that nudges are the more effective behaviorally informed policy in this setting, particularly when the nudge design targets the affect and availability heuristics; however, additional research is necessary to establish sufficient conditions for this conclusion.

## Reproducing [Bradt (2019)](https://doi.org/10.1017/bpp.2019.31)
The entire analysis of Bradt (2019) can be executed by running the master script **`R/replicate.R`** as follows:

```
## Run these commands in a shell
git clone https://github.com/jtbradt/flood-insurance-bpp
cd flood-insurance-bpp
Rscript R/replicate.R
```

The master script includes commented descriptions of the sub-scripts that it sources.  In addition to sourcing the master script, you may replicate the analysis interactively in an *R* console.

## Requirements

#### Step 1: Install R and R libaries

The code was most tested and updated against *R* 4.1.0. *R* is free, open-source and available for download [here](https://www.r-project.org/).

I use [**renv**](https://rstudio.github.io/renv/) to manage R dependencies in the project environment. Run the following command(s) from your *R* console to pull in all of the necessary libraries.

```r
# renv::init()   ## Only necessary if you download the repo directly as opposed to cloning/opening the repo as an RStudio project
renv::restore()  ## Enter "y"
```

#### Step 2: Install system dependencies (only if applicable)

While the `renv::restore()` command above should install [package binaries](https://packagemanager.rstudio.com/) on most operating systems (OS), it will not necessarily import *system* dependencies on some Linux builds.

## Data

The data analyzed in Bradt (2019) and included in this replication repo are derived from a survey of 331 participants recruited to take a survey instrument using Amazon's Mechanical Turk in exchange for a modest payment in April 2019.  Data collected from this survey are pre-processed to remove all identifying data; the resulting anonymized data file **`data/raw/data_raw.csv`** includes only those fields which are necessary to replicate the analysis of Bradt (2019).  This replication repository therefore maintains the anonymity of all survey respondents. 

Additional information on the survey instrument and the data included in **`data/raw/data_raw.csv`** are available in the text of [Bradt (2019)](https://doi.org/10.1017/bpp.2019.31).

## Problems

If you encounter any difficulties running the code or if you find any errors, please file an issue on this repo and I will look into it.

## License

The software code contained within this repository is made available under the [MIT license](http://opensource.org/licenses/mit-license.php). The data and figures are made available under the [Creative Commons Attribution 4.0](https://creativecommons.org/licenses/by/4.0/) license.

## README attribution

This **`README.md`** is based on the README.md from a [replication repo](https://github.com/grantmcdermott/bycatch) owned by [Grant McDermott](https://github.com/grantmcdermott).
