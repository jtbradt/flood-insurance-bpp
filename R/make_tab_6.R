############################## FRONT MATTER ##############################
#   FILENAME:   make_tab_6.R
#   AUTHOR:     Jacob Bradt (jbradt@g.harvard.edu)

# STEP 1: Load packages ---------------

pacman::p_load(data.table, here, stargazer, stats, censReg, VGAM, dplyr)

# STEP 2: Import processed data ---------------

flood <- fread(here("data", "intermediate", "data_inter.csv"))

# STEP 3: Estimate primary specification and fit summary objects ---------------

#   Run primary specification: two-limit tobit
m1 <- censReg(wtp ~ t1 + t2 + t3 + exp_flood + cc + pol + age + children + income + university + standalone + coastal, left = 0,  right = 125, data = flood)
m1_sum <- summary(m1)

#   Extract marginal effects from m1:
m1_me <- as.data.frame(margEff(m1))

#   Calculate likelihood ratio for all model parameters (completely restricted
#   model) and associated p-value:
summary(m2 <- censReg::censReg(wtp ~ 1, left = 0, right = 125, data = flood))
lr_m1_1 <- -2*(logLik(m2) - logLik(m1))
lr_m1_1_psymbol <- pchisq(lr_m1_1, df = 12, lower.tail = FALSE) %>%
  stats::symnum(cutpoints = c(0,0.01, 0.05, 0.1, 1), symbols = c("^{***}","^{**}", "^{*}", ""), na = "") %>%
  as.character()
lr_m1_1_print <- paste0(sprintf("%.3f", round(lr_m1_1, 3)),lr_m1_1_psymbol)

#   Calculate likelihood ratio for the restricted model excluding just the
#   treatment status variables and associated p-value:
summary(m3 <- censReg::censReg(wtp ~ exp_flood + cc + pol + age + children + income + university + standalone + coastal, left = 0, right = 125, data = flood))
lr_m1_2 <- -2*(logLik(m3) - logLik(m1))
lr_m1_2_psymbol <- pchisq(lr_m1_2, df = 3, lower.tail = FALSE) %>%
  stats::symnum(cutpoints = c(0,0.01, 0.05, 0.1, 1), symbols = c("^{***}","^{**}", "^{*}", ""), na = "") %>%
  as.character()
lr_m1_2_print <- paste0(sprintf("%.3f", round(lr_m1_2, 3)),lr_m1_2_psymbol)

# STEP 4: Construct Table 6 ---------------

#   Construct coefficient column:
coefs <- c(m1_sum$estimate[2:13,1], m1_sum$estimate[1,1], exp(m1_sum$estimate[14, 1]))
p_symbols <- c(m1_sum$estimate[2:13,4], m1_sum$estimate[1,4], m1_sum$estimate[14, 4]) %>%
  stats::symnum(cutpoints = c(0,0.01, 0.05, 0.1, 1), symbols = c("^{***}","^{**}", "^{*}", ""), na = "") %>%
  as.character()
coefs_print <- paste0(sprintf("%.3f", round(coefs, 3)), p_symbols)

#   Construct standard error column:
ster <- sprintf("%.3f", round(c(m1_sum$estimate[2:13,2], m1_sum$estimate[1,2], exp(m1_sum$estimate[14, 2])),3))

#   Construct marginal effect column:
meff <- c(sprintf("%.3f", round(m1_me[,1],3)), "-", "-")

#   Construct full table:
full_tab <- rbind(
  matrix(
    c(coefs_print, ster, meff), 
    ncol = 3
  ), 
  matrix(
    c(
      rep("-", 8), nrow(flood), 
      m1_sum$loglik,
      lr_m1_1_print,
      lr_m1_2_print
    ), 
    ncol = 3
  )
)

#   Define row names:
rownames(full_tab) <- c("(Treatment 1)_i", "(Treatment 2a)_i", "(Treatment 2b)_i", "FloodExp_i", "ClimatePrior_i", "Political_i", "Age_i", "Children_i", "Income_i", "University_i", "DetachedHome_i", "CoastalState_i", "Constant", "sigma", "Observations", "Log likelihood", "-2log(L_{R1}/L_{U})", "-2log(L_{R2}/L_{U})")

#   Define column names:
colnames(full_tab) <- c("Coefficient", "Standard error", "Marginal effect")

#   Write Table 6 to .tex file
stargazer(
  full_tab, 
  colnames = T,
  out = here("results", "tab6.tex")
)

#   Clear workspace:
rm(list = ls())
