############################## FRONT MATTER ##############################
#   FILENAME:   make_tab_3.R
#   AUTHOR:     Jacob Bradt (jbradt@g.harvard.edu)

# STEP 1: Import raw data ---------------

flood <- fread(here("data", "raw", "data_raw.csv"))

# STEP 2: Subset data for descriptive statistics ---------------

flood_descrip <-
  subset(
    flood,
    select = -c(
      cost,
      wtp,
      purchase,
      t0,
      t1,
      t2,
      t3,
      minority,
      married,
      unemployed,
      university
    )
  )

# STEP 3: Write descriptive statistics to .tex file ---------------

#   Define variable order:
order <- c(12:16, 1:6, 17:18, 7, 16, 8:10)

#   Define summary statistics to omit:
stat.omit <- c("max", "min", "N", "p25", "p75")

#   Write descriptive statistics to .tex file
stargazer(
  flood_descrip,
  omit.summary.stat = stat.omit,
  order = order,
  out = here("results", "tab3.tex")
)

#   Clear workspace:
rm(list = ls())
