# Initialize parameters and change work directory
library(car)
setwd('/Users/hectorOrozco/Desktop/binauralBeats/analysis/3-steadystate_cortical')
SSEP.idata = read.csv("SSEP_levels.csv") # I created this file manually

# Theta anova
SSEPtheta = read.csv("SSEP7.csv")  # read csv file; I added the header manually
SSEPtheta.mat <- as.matrix(SSEPtheta)
SSEPtheta.mlm <- lm(SSEPtheta.mat ~1)
SSEPtheta.aov <- Anova(SSEPtheta.mlm, idata=SSEP.idata, idesign=~Type*Frequency,type="III")
summary(SSEPtheta.aov,multivariate=F)
## We get a significant main effects and a marginal interaction, so I'm getting Omega for a and b
(type_partial_omega_squared = (2-1)*(7.6686-1)/((2-1)*(7.6686-1)+(16*2*2)))
(frequency_partial_omega_squared = (2-1)*(19.2633-1)/((2-1)*(19.2633-1)+(16*2*2)))

# Gamma anova, to do: report effect sizes, then paired t-tests (the three that you thought about with David) 
SSEPgamma = read.csv("SSEP40.csv")  # read csv file; I added the header manually
SSEPgamma.mat <- as.matrix(SSEPgamma)
SSEPgamma.mlm <- lm(SSEPgamma.mat ~1)
SSEPgamma.aov <- Anova(SSEPgamma.mlm, idata= SSEP.idata, idesign=~Type*Frequency,type="III")
summary(SSEPgamma.aov,multivariate=F)
## We get a significant everything, so I'm getting Omega for everything and then further exploring these differences
(type_partial_omega_squared = (2 - 1)*(34.5383-1)/((2-1)*(34.5383-1)+(16*2*2)))
(frequency_partial_omega_squared = (2 - 1)*(51.9329-1)/((2-1)*(51.9329-1)+(16*2*2)))
(typexfrequency_partial_omega_squared = (2 - 1)*(2-1)*(44.2841-1)/((2-1)*(2-1)*(44.2841-1)+(16*2*2)))

## We further examin differences with paired t-tests. We doing 3 paired-t-tests, so we use the Holm's sequential Bonferroni test. It is a slightly modification of the Bonferroni test to increase its power significantly. We first rank the absolute values of the statistics of the comparisons from highest to lowest (as I did in the next lines) and we then evalure the first comparison against alpha/number_comparisons, the second one at (alpha/number_comparisons -1), the third one (alpha/number_comparisons-2) OR until something is not significant. In this case, significance holds for all of this. 
t.test(SSEPgamma$Monaural.Gamma, SSEPgamma$Monaural.Theta, paired = TRUE)
# Evaluate at 0.05 / 3 = 0.01666667

t.test(SSEPgamma$Binaural.Gamma, SSEPgamma$Monaural.Gamma, paired = TRUE)
# Evaluate at 0.05 / 2 = 0.025

t.test(SSEPgamma$Binaural.Gamma, SSEPgamma$Binaural.Theta, paired = TRUE)
# Evaluate at 0.05 / 1 = 0.05
