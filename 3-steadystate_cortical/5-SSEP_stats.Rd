
##################################################
## Project: Binaural Beats
## Script purpose: Statistical testing of cortical steady state responses
## Author: Hector D Orozco Perez
## Contact: hector.dom.orozco@gmail.com
## License: GNU GPL v3
##################################################

# Initialize parameters and change work directory
library(car)
set.seed(99)
setwd('/Users/hectordorozcoperez/Desktop/binauralBeats/analysis/3-steadystate_cortical')
SSEP.idata = read.csv("SSEP_levels.csv") # I created this file manually

## Theta anova
# get the linear model going
SSEPtheta = read.csv("SSEP7.csv") # read csv file; I added the header manually
SSEPtheta.mat <- as.matrix(SSEPtheta)
SSEPtheta.mlm <- lm(SSEPtheta.mat ~1)

# check for normality
shapiro.test(residuals(SSEPtheta.mlm))  

# to keep things internally consistent, we do permutation statistics (some of our data is not normally distributed)
SSEPtheta.aov <- Anova(SSEPtheta.mlm, idata=SSEP.idata, idesign=~Type*Frequency,type="III")
summary_data <- summary(SSEPtheta.aov,multivariate=F)
original_f_type <- summary_data$univariate.tests[18]
original_f_frequency <- summary_data$univariate.tests[19]
original_f_interaction <- summary_data$univariate.tests[20]

# some of the data in the project isn't normal, so to keep things consistent, we decided to do permutation tests all around
F_distribution_frequency <- vector(mode="double", length=1000)
F_distribution_type <- vector(mode="double", length=1000)
F_distribution_interaction <- vector(mode="double", length=1000)

for (i in 1:1000){
  shuffled_ssept <- SSEPtheta  # permute data, but only the rows (within design)
  for (n in 1:nrow(shuffled_ssept)){
    shuffled_ssept[n,] <- sample(shuffled_ssept[n,])
  }
  SSEPtheta.mat <- as.matrix(shuffled_ssept)
  SSEPtheta.mlm <- lm(SSEPtheta.mat~1)
  SSEPtheta.aov <- Anova(SSEPtheta.mlm, idata=SSEP.idata, idesign=~Type*Frequency,type="III")
  summary_data <- summary(SSEPtheta.aov,multivariate=F)
  F_distribution_type[i] <- summary_data$univariate.tests[18]
  F_distribution_frequency[i] <- summary_data$univariate.tests[19]
  F_distribution_interaction[i] <- summary_data$univariate.tests[20]
}
p_value_temp_type <- F_distribution_type > original_f_type
p_value_type <- length(p_value_temp_type[p_value_temp_type == TRUE]) / length(p_value_temp_type)
CI_type = sort(F_distribution_type)[c(25, 975)]

p_value_temp_frequency <- F_distribution_frequency > original_f_frequency
p_value_frequency <- length(p_value_temp_frequency[p_value_temp_frequency == TRUE]) / length(p_value_temp_frequency)
CI_frequency = sort(F_distribution_frequency)[c(25, 975)]

p_value_temp_interaction <- F_distribution_interaction > original_f_interaction
p_value_interaction <- length(p_value_temp_interaction[p_value_temp_interaction == TRUE]) / length(p_value_temp_interaction)
CI_interaction = sort(F_distribution_interaction)[c(25, 975)]


# We get a significant main effects and a marginal interaction, so I'm getting Omega for a and b
# (type_partial_omega_squared = (2-1)*(7.6686-1)/((2-1)*(7.6686-1)+(16*2*2)))
# (frequency_partial_omega_squared = (2-1)*(19.2633-1)/((2-1)*(19.2633-1)+(16*2*2)))


## Gamma anova
# get the linear model going
SSEPgamma = read.csv("SSEP40.csv") # read csv file; I added the header manually
SSEPgamma.mat <- as.matrix(SSEPgamma)
SSEPgamma.mlm <- lm(SSEPgamma.mat ~1)

# check for normality
shapiro.test(residuals(SSEPgamma.mlm))  

# to keep things internally consistent, we do permutation statistics (some of our data is not normally distributed)
SSEPgamma.aov <- Anova(SSEPgamma.mlm, idata=SSEP.idata, idesign=~Type*Frequency,type="III")
summary_data <- summary(SSEPgamma.aov,multivariate=F)
original_f_type <- summary_data$univariate.tests[18]
original_f_frequency <- summary_data$univariate.tests[19]
original_f_interaction <- summary_data$univariate.tests[20]

F_distribution_frequency <- vector(mode="double", length=1000)
F_distribution_type <- vector(mode="double", length=1000)
F_distribution_interaction <- vector(mode="double", length=1000)

for (i in 1:1000){
  shuffled_ssepg <- SSEPgamma  # permute data, but only the rows (within design)
  for (n in 1:nrow(shuffled_ssepg)){
    shuffled_ssepg[n,] <- sample(shuffled_ssepg[n,])
  }
  SSEPgamma.mat <- as.matrix(shuffled_ssepg)
  SSEPgamma.mlm <- lm(SSEPgamma.mat~1)
  SSEPgamma.aov <- Anova(SSEPgamma.mlm, idata=SSEP.idata, idesign=~Type*Frequency,type="III")
  summary_data <- summary(SSEPgamma.aov,multivariate=F)
  F_distribution_type[i] <- summary_data$univariate.tests[18]
  F_distribution_frequency[i] <- summary_data$univariate.tests[19]
  F_distribution_interaction[i] <- summary_data$univariate.tests[20]
}
p_value_temp_type <- F_distribution_type > original_f_type
p_value_type <- length(p_value_temp_type[p_value_temp_type == TRUE]) / length(p_value_temp_type)
CI_type = sort(F_distribution_type)[c(25, 975)]

p_value_temp_frequency <- F_distribution_frequency > original_f_frequency
p_value_frequency <- length(p_value_temp_frequency[p_value_temp_frequency == TRUE]) / length(p_value_temp_frequency)
CI_frequency = sort(F_distribution_frequency)[c(25, 975)]

p_value_temp_interaction <- F_distribution_interaction > original_f_interaction
p_value_interaction <- length(p_value_temp_interaction[p_value_temp_interaction == TRUE]) / length(p_value_temp_interaction)
CI_interaction = sort(F_distribution_interaction)[c(25, 975)]

## We get a significant everything, so I'm getting Omega for everything and then further exploring these differences
# (type_partial_omega_squared = (2 - 1)*(34.5383-1)/((2-1)*(34.5383-1)+(16*2*2)))
# (frequency_partial_omega_squared = (2 - 1)*(51.9329-1)/((2-1)*(51.9329-1)+(16*2*2)))
# (typexfrequency_partial_omega_squared = (2 - 1)*(2-1)*(44.2841-1)/((2-1)*(2-1)*(44.2841-1)+(16*2*2)))

## We further examin differences with permuted paired t-tests. We doing 3 paired-t-tests, so we use the Holm's sequential Bonferroni test. It is a slightly modification of the Bonferroni test to increase its power significantly. We first rank the absolute values of the statistics of the comparisons from highest to lowest (as I did in the next lines) and we then evalure the first comparison against alpha/number_comparisons, the second one at (alpha/number_comparisons -1), the third one (alpha/number_comparisons-2) OR until something is not significant. In this case, significance holds for all of this. 

# Evaluate at 0.05 / 3 = 0.01666667, or you can multiply the value by 3! 
t_distribution <- vector(mode="double", length=1000)
SSEPmatrix <- cbind(SSEPgamma$Monaural.Gamma, SSEPgamma$Monaural.Theta)
summary_table <- t.test(SSEPgamma$Monaural.Gamma, SSEPgamma$Monaural.Theta, paired = TRUE)
original_t = summary_table$statistic
for (i in 1:1000){
  shuffled_matrix <- SSEPmatrix  # permute data, but only the rows (within design)
  for (n in 1:nrow(shuffled_matrix)){
    shuffled_matrix[n,] <- sample(shuffled_matrix[n,])
  }
  summary_table <- t.test(shuffled_matrix[,1], shuffled_matrix[,2], paired = TRUE)
  t_distribution[i] = summary_table$statistic
}
p_value_temp <- abs(t_distribution) > abs(original_t)
p_value <- length(p_value_temp[p_value_temp == TRUE]) / length(p_value_temp)
CI_t = sort(t_distribution)[c(25, 975)]

# Evaluate at 0.05 / 2 = 0.025
t_distribution <- vector(mode="double", length=1000)
SSEPmatrix <- cbind(SSEPgamma$Binaural.Gamma, SSEPgamma$Monaural.Gamma)
summary_table <- t.test(SSEPgamma$Binaural.Gamma, SSEPgamma$Monaural.Gamma, paired = TRUE)
original_t = summary_table$statistic
for (i in 1:1000){
  shuffled_matrix <- SSEPmatrix  # permute data, but only the rows (within design)
  for (n in 1:nrow(shuffled_matrix)){
    shuffled_matrix[n,] <- sample(shuffled_matrix[n,])
  }
  summary_table <- t.test(shuffled_matrix[,1], shuffled_matrix[,2], paired = TRUE)
  t_distribution[i] = summary_table$statistic
}
p_value_temp <- abs(t_distribution) > abs(original_t)
p_value <- length(p_value_temp[p_value_temp == TRUE]) / length(p_value_temp)
CI_t = sort(t_distribution)[c(25, 975)]

# Evaluate at 0.05 / 1 = 0.05
t_distribution <- vector(mode="double", length=1000)
SSEPmatrix <- cbind(SSEPgamma$Binaural.Gamma, SSEPgamma$Binaural.Theta)
summary_table <- t.test(SSEPgamma$Binaural.Gamma, SSEPgamma$Binaural.Theta, paired = TRUE)
original_t = summary_table$statistic
for (i in 1:1000){
  shuffled_matrix <- SSEPmatrix  # permute data, but only the rows (within design)
  for (n in 1:nrow(shuffled_matrix)){
    shuffled_matrix[n,] <- sample(shuffled_matrix[n,])
  }
  summary_table <- t.test(shuffled_matrix[,1], shuffled_matrix[,2], paired = TRUE)
  t_distribution[i] = summary_table$statistic
}
p_value_temp <- abs(t_distribution) > abs(original_t)
p_value <- length(p_value_temp[p_value_temp == TRUE]) / length(p_value_temp)
CI_t = sort(t_distribution)[c(25, 975)]