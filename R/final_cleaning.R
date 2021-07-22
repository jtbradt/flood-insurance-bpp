############################## FRONT MATTER ##############################
#   FILENAME:   final_cleaning.R
#   AUTHOR:     Jacob Bradt (jbradt@g.harvard.edu)

# STEP 1: Load packages ---------------

pacman::p_load(data.table, here, psych, dplyr)

# STEP 2: Import raw data ---------------

flood <- fread(here("data", "raw", "data_raw.csv"))

# STEP 3: Construct aggregate political view variable ---------------

#   Aggregate political ideology and political party affiliation variables:
flood$pol <- flood$pol_ideol + flood$pol_party

#   Calculate Cronbach's alpha for political ideology and political party
#   affiliation variables (value reported in notes of Tables 6 and 7):
alpha(matrix(c(flood$pol_ideol, flood$pol_party),ncol=2))

#   Normalize aggregate political views variable (note normalization, not
#   Z-score:
flood$pol <- (flood$pol - mean(flood$pol)/sd(flood$pol))

# STEP 4: Construct aggregate climate change belief variable ---------------

#   Aggregate variables describing climate change and sea level rise priors:
flood$cc <- flood$prior_cc + flood$prior_slr

#   Calculate Cronbach's alpha for variables describing climate change and sea
#   level rise priors (value reported in notes of Tables 6 and 7):
alpha(matrix(c(flood$prior_cc, flood$prior_slr), ncol = 2))

#   Normalize aggregate climate change beliefs variable (note normalization, not
#   Z-score:
flood$cc <- (flood$cc - mean(flood$cc))/sd(flood$cc)

# STEP 5: Construct Z-score for motivation variables ---------------

#   Construct quantile variable for Z-score of each of the situational
#   motivation variables:
flood$sit_w <- (flood$sit_worry - mean(flood$sit_worry))/sd(flood$sit_worry)
flood$sit_p <- (flood$sit_prepare - mean(flood$sit_prepare))/sd(flood$sit_prepare)
flood$glob_f <- (flood$glob_finan - mean(flood$glob_finan))/sd(flood$glob_finan)
flood$glob_s <- (flood$glob_safe - mean(flood$glob_safe))/sd(flood$glob_safe)

#   Construct quantile variable for Z-score of combined situational motivation
#   variables:
flood$sit_sum <- flood$sit_prepare + flood$sit_worry
flood$sit <- (flood$sit_sum - mean(flood$sit_sum))/sd(flood$sit_sum)
flood <- flood %>% mutate(sit = ntile(sit, 7))

# STEP 6: Construct premium variables ---------------

#   Construct stated perceived premium variable (stated WTP minus stated
#   anticipated cost):
flood$prem_perceived <- flood$wtp - flood$cost

#   Construct implied perceived premium variable (stated WTP minus actuarially
#   fair rate):
flood$prem_actual <- flood$wtp - 62.5

# STEP 7: Save processed data file ---------------

#   Save processed data to intermediate data directory:
fwrite(flood, here("data", "intermediate", "data_inter.csv"))

#   Clear workspace:
rm(list = ls())

