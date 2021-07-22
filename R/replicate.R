############################## FRONT MATTER ##############################
#   REPLICATION FILE
#   AUTHOR:   Jacob Bradt (jbradt@g.harvard.edu)
#   TITLE:    Comparing the effects of behaviorally informed interventions 
#             on flood insurance demand: an experimental analysis of 
#             'boosts' and 'nudges'
#   JOURNAL:  Behavioural Public Policy
#   NOTES:    R code for reproducing "Comparing the effects of behaviorally
#   informed interventions on flood insurance demand: an experimental analysis
#   of 'boosts' and 'nudges'" (link: https://doi.org/10.1017/bpp.2019.31).
############################## FRONT MATTER ##############################

# renv::init()   ## Only necessary if you didn't clone/open the repo as an RStudio project
renv::restore()  ## Enter "y" when prompted

#   Load packages:
library(here)
library(data.table)
library(psych)
library(dplyr)
library(ggplot2)
library(gplots)
library(stargazer)
library(stats)
library(censReg)
library(VGAM)

#   Initialize top-level directory:
i_am("R/replicate.R")

# Final processing of anonymized raw data ---------------
#     Description: Imports anonymized, pre-processed raw data from ~/data/raw/,
#     generates variables used in analysis, and saves processed intermediate/
#     data to ~/data/intermediate.
source(here("R", "final_cleaning.R"))

# Make Figures 1 through 4 and Appendix D ---------------
#     Description: Uses processed intermediate data from ~/data/intermediate/ to
#     generate Figures 1 through 4 in the text as well as Appendix D in the
#     Supplementary Materials and saves the resulting image files to ~/results/.
source(here("R", "make_figs.R"))

# Make Table 3 ---------------
#     Description: Uses processed intermediate data from ~/data/intermediate/ to
#     generate Table 3 from the text and saves the resulting .tex file to
#     ~/results/. To view results in the console, open and run/execute the
#     script sourced below (i.e., do not source).
source(here("R", "make_tab_3.R"))

# Make Table 4 ---------------
#     Description: Uses processed intermediate data from ~/data/intermediate/ to
#     generate Table 4 from the text and saves the resulting .tex file to
#     ~/results/. To view results in the console, open and run/execute the
#     script sourced below (i.e., do not source).
source(here("R", "make_tab_4.R"))

# Make Table 5 ---------------
#     Description: Uses processed intermediate data from ~/data/intermediate/ to
#     generate Table 5 from the text and saves the resulting .tex file to
#     ~/results/. To view results in the console, open and run/execute the
#     script sourced below (i.e., do not source).
source(here("R", "make_tab_5.R"))

# Make Table 6 ---------------
#     Description: Uses processed intermediate data from ~/data/intermediate/ to
#     generate Table 6 from the text and saves the resulting .tex file to
#     ~/results/. To view results in the console, open and run/execute the
#     script sourced below (i.e., do not source).
source(here("R", "make_tab_6.R"))

# Make Table 7 ---------------
#     Description: Uses processed intermediate data from ~/data/intermediate/ to
#     generate Table 7 from the text and saves the resulting .tex file to
#     ~/results/. To view results in the console, open and run/execute the
#     script sourced below (i.e., do not source).
source(here("R", "make_tab_7.R"))
