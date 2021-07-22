############################## FRONT MATTER ##############################
#   FILENAME:   make_tab_7.R
#   AUTHOR:     Jacob Bradt (jbradt@g.harvard.edu)

# STEP 1: Import processed data ---------------

flood <- fread(here("data", "intermediate", "data_inter.csv"))

# STEP 2: Estimate primary specification and fit summary objects ---------------

#   Run motivation specification: two-limit tobit
summary(m4 <- censReg::censReg(wtp ~ t1 + t2 + t3 + sit_p + sit_w + glob_f + glob_s + exp_flood + cc + pol + age + children + income + university + standalone + coastal, left = 0, right = 125,data = flood))
m4_sum <- summary(m4)

#   Extract marginal effects from m1:
m4_me <- as.data.frame(margEff(m4))

#   Calculate likelihood ratio for all model parameters (completely restricted
#   model) and associated p-value:
summary(m5 <- censReg::censReg(wtp ~ 1, left = 0, right = 125, data = flood))
lr_m4_1 <- -2*(logLik(m5) - logLik(m4))
lr_m4_1_psymbol <- pchisq(lr_m4_1, df = 16, lower.tail = FALSE) %>%
  stats::symnum(cutpoints = c(0,0.01, 0.05, 0.1, 1), symbols = c("^{***}","^{**}", "^{*}", ""), na = "") %>%
  as.character()
lr_m4_1_print <- paste0(sprintf("%.3f", round(lr_m4_1, 3)),lr_m4_1_psymbol)

#   Calculate likelihood ratio for the restricted model excluding just the
#   treatment status variables and associated p-value:
summary(m6 <- censReg::censReg(wtp ~ sit_prepare + sit_worry + glob_finan + glob_safe + exp_flood + cc + pol + age + children + income + university + standalone + coastal, left = 0, right = 125, data = flood))
lr_m4_2 <- -2*(logLik(m6) - logLik(m4))
lr_m4_2_psymbol <- pchisq(lr_m4_2, df = 3, lower.tail = FALSE) %>%
  stats::symnum(cutpoints = c(0,0.01, 0.05, 0.1, 1), symbols = c("^{***}","^{**}", "^{*}", ""), na = "") %>%
  as.character()
lr_m4_2_print <- paste0(sprintf("%.3f", round(lr_m4_2, 3)),lr_m4_2_psymbol)

# STEP 3: Construct Table 7 ---------------

#   Construct coefficient column:
coefs <- c(m4_sum$estimate[2:17,1], m4_sum$estimate[1,1], exp(m4_sum$estimate[18, 1]))
p_symbols <- c(m4_sum$estimate[2:17,4], m4_sum$estimate[1,4], m4_sum$estimate[18, 4]) %>%
  stats::symnum(cutpoints = c(0,0.01, 0.05, 0.1, 1), symbols = c("^{***}","^{**}", "^{*}", ""), na = "") %>%
  as.character()
coefs_print <- paste0(sprintf("%.3f", round(coefs, 3)), p_symbols)

#   Construct standard error column:
ster <- sprintf("%.3f", round(c(m4_sum$estimate[2:17,2], m4_sum$estimate[1,2], exp(m4_sum$estimate[18, 2])),3))

#   Construct marginal effect column:
meff <- c(sprintf("%.3f", round(m4_me[,1],3)), "-", "-")

#   Construct full table:
full_tab <- rbind(
  matrix(
    c(coefs_print, ster, meff), 
    ncol = 3
  ), 
  matrix(
    c(
      rep("-", 8), nrow(flood), 
      m4_sum$loglik,
      lr_m4_1_print,
      lr_m4_2_print
    ), 
    ncol = 3
  )
)

#   Define row names:
rownames(full_tab) <- c("(Treatment 1)_i", "(Treatment 2a)_i", "(Treatment 2b)_i", "Situational_Worry_i", "Situational_Prepare_i", "Global_Financial_i", "Global_Safe_i", "FloodExp_i", "ClimatePrior_i", "Political_i", "Age_i", "Children_i", "Income_i", "University_i", "DetachedHome_i", "CoastalState_i", "Constant", "sigma", "Observations", "Log likelihood", "-2log(L_{R1}/L_{U})", "-2log(L_{R2}/L_{U})")

#   Define column names:
colnames(full_tab) <- c("Coefficient", "Standard error", "Marginal effect")

#   Write Table 7to .tex file
stargazer(
  full_tab, 
  colnames = T,
  out = here("results", "tab7.tex")
)

#   Clear workspace:
rm(list = ls())
