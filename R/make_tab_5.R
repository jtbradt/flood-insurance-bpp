############################## FRONT MATTER ##############################
#   FILENAME:   make_tab_5.R
#   AUTHOR:     Jacob Bradt (jbradt@g.harvard.edu)

# STEP 1: Load packages ---------------

pacman::p_load(data.table, here, stargazer, stats)

# STEP 2: Import processed data ---------------

flood <- fread(here("data", "intermediate", "data_inter.csv"))

# STEP 3: Calculate Tukey's HSD ---------------

#   Analysis of variance:
res.aov <- aov(wtp ~ t, data = flood)

#   Tukey's HSD:
tukey <- TukeyHSD(res.aov)

# STEP 4: Construct Table 5 ---------------

#   Write Table 5 to .tex file
stargazer(
  tukey$t, 
  notes = paste0("One-way analysis of variance testing H0: no difference between the mean willingness to pay across Treatment and Control groups rejects the null hypothesis with F-value of ", round(summary(res.aov)[[1]]$`F value`[1],3), " (p=", round(summary(res.aov)[[1]]$`Pr(>F)`[1], 3), ")."),
  out = here("results", "tab5.tex")
)

#   Clear workspace:
rm(list = ls())


