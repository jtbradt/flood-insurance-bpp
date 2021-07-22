############################## FRONT MATTER ##############################
#   FILENAME:   make_tab_4.R
#   AUTHOR:     Jacob Bradt (jbradt@g.harvard.edu)

# STEP 1: Import processed data ---------------

flood <- fread(here("data", "intermediate", "data_inter.csv"))

# STEP 2: Construct Table 4 ---------------

#   Create matrix of WTI/WTP/CWTP (with std errors for WTP and CWTP) for full
#   sample:
wtp_results_full <-
  matrix(
    c(
      paste0("Full sample (n=", length(flood$wtp),")"),
      paste0(sprintf("%.2f", round(mean(flood$purchase) * 100, 2))),
      paste0(
        sprintf("%.2f", round(mean(flood$wtp), 2)), " (", 
        sprintf("%.2f", round((sd(flood$wtp) / sqrt(length(flood$wtp))),2)), ")"
      ),
      paste0(
        sprintf("%.2f", round(mean(flood[flood$purchase == 1, ]$wtp),2)), " (", 
        sprintf("%.2f", round((sd(flood[flood$purchase == 1, ]$wtp) / sqrt(length(flood[flood$purchase == 1, ]$wtp))),2)), ")"
      )
    ),
    nrow = 1,
    ncol = 4,
    byrow = TRUE
  )

#   Create matrix of WTI/WTP/CWTP (with std errors for WTP and CWTP) for each
#   treatment group:
cond_list <- c("Control","Treatment 1","Treatment 2a","Treatment 2b")
wtp_results_cond <- lapply(1:4, function(x){
  
  #   For given treatment group x, create row of WTI, WTP, and CWTP (with std
  #   errors for WTP and CWTP):
  temp <- matrix(
    c(
      paste0(cond_list[1], " (n=",nrow(flood[flood$t==cond_list[x],]), ")"),
      paste0(sprintf("%.2f", round(mean(flood[flood$t==cond_list[x],]$purchase)*100,2))), 
      paste0(
        sprintf("%.2f", round(mean(flood[t==cond_list[x],]$wtp),2)), " (",
        sprintf("%.2f", round((sd(flood[t==cond_list[x],]$wtp)/sqrt(length(flood[t==cond_list[x],]$wtp))),2)), ")"
      ), 
      paste0(
        sprintf("%.2f", round(mean(flood[t==cond_list[x] & purchase == 1,]$wtp),2)), " (",
        sprintf("%.2f", round((sd(flood[t==cond_list[x] & purchase == 1,]$wtp)/sqrt(length(flood[t==cond_list[x] & purchase == 1,]$wtp))),2)), ")"
      )    
    ),
    nrow = 1,
    ncol = 4,
    byrow = TRUE
  )

  return(temp)
})

#   Bind rows of Table 4 together:
wtp_results_tab <- matrix(c(wtp_results_full, unlist(wtp_results_cond)), ncol = 4, byrow = T)

#   Define column labels:
colnames(wtp_results_tab) <- c("Group", "WTI", "WTP", "CWTP")

#   Write Table 4 to .tex file
stargazer(
  wtp_results_tab, 
  colnames = T, 
  notes = c("Note: Standard errors reported in parentheses."), 
  out = here("results", "tab4.tex")
)

#   Clear workspace:
rm(list = ls())
