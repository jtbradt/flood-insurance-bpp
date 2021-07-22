############################## FRONT MATTER ##############################
#   FILENAME:   make_figs.R
#   AUTHOR:     Jacob Bradt (jbradt@g.harvard.edu)

# STEP 1: Load packages ---------------

pacman::p_load(data.table, here, gplots, ggplot2, dplyr)

# STEP 2: Import processed data ---------------

flood <- fread(here("data", "intermediate", "data_inter.csv"))

# STEP 3: Make figures ---------------

#   Figure 1:
jpeg(here("results", "Figure1a.jpg"), width = 7, height = 5, units = 'in', res = 500)
par(mfrow=c(1,1))
plotmeans(wtp ~ t, data = flood, xlab = "", ylab = "WTP ($/month)", connect = FALSE, n.label = FALSE)
dev.off()
jpeg(here("results", "Figure1b.jpg"), width = 7, height = 5, units = 'in', res = 500)
par(mfrow=c(1,1))
plotmeans(wtp ~ t, data = flood[flood$wtp!=0,], xlab = "", ylab = "CWTP ($/month)", connect = FALSE, n.label = FALSE)
dev.off()

#   Figure 2:
norm_dens <- function(x, var, bw = (125/9)) {
  dnorm(x, mean = mean(var), sd(var)) * length(var)  * bw
}
ggplot(flood, aes(x=wtp)) + 
  stat_bin(binwidth = (125/9), colour="black", fill="lightblue") +
  stat_function(fun = norm_dens, size = 1, args = list(var = flood$wtp)) + theme_minimal() +
  theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
  xlab("WTP ($/month)") + ylab("Frequency")
ggsave(here("results", "Figure2.jpg"), plot = last_plot(), scale = 1, dpi = 500)

#   Figure 3:
jpeg(here("results","Figure3.jpg"), width = 11, height = 5.92, units = 'in', res = 500)
par(mfrow=c(2,2))
plotmeans(sit_w ~ t, flood, ylab = "Situational Worry", xlab = "", n.label = FALSE, connect = FALSE)
plotmeans(sit_p ~ t, flood, ylab = "Situational Preparation", xlab = "", n.label = FALSE, connect = FALSE)
plotmeans(glob_s ~ t, flood, ylab = "Global Safety", xlab = "", n.label = FALSE, connect = FALSE)
plotmeans(glob_f ~ t, flood, ylab = "Global Financial Security", xlab = "", n.label = FALSE, connect = FALSE)
dev.off()

#   Figure 4:
jpeg(here("results","Figure4a.jpg"), width = 7, height = 5, units = 'in', res = 500)
par(mfrow=c(1,1))
plotmeans(purchase ~ sit, flood, xlab = "Situational Motivation", ylab = "WTI", n.label = FALSE)
dev.off()
jpeg(here("results","Figure4b.jpg"), width = 7, height = 5, units = 'in', res = 500)
par(mfrow=c(1,1))
plotmeans(wtp ~ sit, flood, xlab = "Situational Motivation", ylab = "WTP ($/month)", n.label = FALSE)
dev.off()

#   Appendix D:
mu <- flood %>%
  group_by(t) %>%
  summarise(grp.mean=mean(wtp))
ggplot(flood, aes(x = wtp, color = t, fill = t)) +
  geom_vline(data=mu, aes(xintercept=grp.mean, color=t), linetype="dashed") +
  geom_density(alpha=.2) + facet_grid(t ~ .) + theme_minimal() + theme(legend.position = "none") +
  xlab("WTP ($/month)") + ylab("Density")
ggsave(here("results","AppendixD.jpg"), plot = last_plot(), scale = 1, dpi = 500)

#   Clear workspace:
rm(list = ls())
