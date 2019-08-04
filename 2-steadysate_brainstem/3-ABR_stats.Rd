
##################################################
## Project: Binaural Beats
## Script purpose: Statistical testing of brainstem responses
## Author: Hector D Orozco Perez
## Contact: hector.dom.orozco@gmail.com
## License: GNU GPL v3
##################################################

# Initialize parameters and change work directory
library(car)
set.seed(99)
setwd('/Users/hectordorozcoperez/Desktop/binauralBeats/analysis/2-steadysate_brainstem')
ABR.idata = read.csv("ABR_levels.csv") # I created this file manually


## Theta relevant anova
# get the linear model going
ABRtheta = read.csv("ABRtheta_relevanTones.csv")  # read csv file; I added the header manually
ABRtheta.mat <- as.matrix(ABRtheta)
ABRtheta.mlm <- lm(ABRtheta.mat~1)

# check for normality
shapiro.test(residuals(ABRtheta.mlm))  

# to keep things internally consistent, we do permutation statistics (some of our data is not normally distributed)
ABRtheta.aov <- Anova(ABRtheta.mlm, idata=ABR.idata, idesign=~Type*Frequency,type="III")
summary_data <- summary(ABRtheta.aov,multivariate=F)
original_f_type <- summary_data$univariate.tests[18]
original_f_frequency <- summary_data$univariate.tests[19]
original_f_interaction <- summary_data$univariate.tests[20]

# some of the data in the project isn't normal, so to keep things consistent, we decided to do permutation tests all around
F_distribution_frequency <- vector(mode="double", length=1000)
F_distribution_type <- vector(mode="double", length=1000)
F_distribution_interaction <- vector(mode="double", length=1000)

for (i in 1:1000){
  shuffled_abrt <- ABRtheta  # permute data, but only the rows (within design)
  for (n in 1:nrow(shuffled_abrt)){
    shuffled_abrt[n,] <- sample(shuffled_abrt[n,])
  }
  ABRtheta.mat <- as.matrix(shuffled_abrt)
  ABRtheta.mlm <- lm(ABRtheta.mat~1)
  ABRtheta.aov <- Anova(ABRtheta.mlm, idata=ABR.idata, idesign=~Type*Frequency,type="III")
  summary_data <- summary(ABRtheta.aov,multivariate=F)
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

# (theta_partial_omega_squared = (2-1)*(34.5733-1)/((2-1)*(34.5733-1)+(16*2*2)))  


## Gamma relevant anova
ABRgamma = read.csv("ABRgamma_relevanTones.csv")  # read csv file; I added the header manually
ABRgamma.mat <- as.matrix(ABRgamma)
ABRgamma.mlm <- lm(ABRgamma.mat~1)

# check for normality
shapiro.test(residuals(ABRgamma.mlm))  

# to keep things internally consistent, we do permutation statistics (some of our data is not normally distributed)
ABRgamma.aov <- Anova(ABRgamma.mlm, idata=ABR.idata, idesign=~Type*Frequency,type="III")
summary_data <- summary(ABRgamma.aov,multivariate=F)
original_f_type <- summary_data$univariate.tests[18]
original_f_frequency <- summary_data$univariate.tests[19]
original_f_interaction <- summary_data$univariate.tests[20]

F_distribution_frequency <- vector(mode="double", length=1000)
F_distribution_type <- vector(mode="double", length=1000)
F_distribution_interaction <- vector(mode="double", length=1000)

for (i in 1:1000){
  shuffled_abrg <- ABRgamma  # permute data, but only the rows (within design)
  for (n in 1:nrow(shuffled_abrg)){
    shuffled_abrg[n,] <- sample(shuffled_abrg[n,])
  }
  ABRgamma.mat <- as.matrix(shuffled_abrg)
  ABRgamma.mlm <- lm(ABRgamma.mat~1)
  ABRgamma.aov <- Anova(ABRgamma.mlm, idata=ABR.idata, idesign=~Type*Frequency,type="III")
  summary_data <- summary(ABRgamma.aov,multivariate=F)
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

# (gamma_partial_omega_squared = (2 - 1)*(26.6484-1)/((2-1)*(26.6484-1)+(16*2*2)))
