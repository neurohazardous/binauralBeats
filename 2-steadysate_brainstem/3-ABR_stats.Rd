# Initialize parameters and change work directory
library(car)
setwd('/Users/hectorOrozco/Desktop/binauralBeats/analysis/2-steadysate_brainstem')
ABR.idata = read.csv("ABR_levels.csv") # I created this file manually

# Theta relevant anova
ABRtheta = read.csv("ABRtheta_relevanTones.csv")  # read csv file; I added the header manually
ABRtheta.mat <- as.matrix(ABRtheta)
ABRtheta.mlm <- lm(ABRtheta.mat~1)
ABRtheta.aov <- Anova(ABRtheta.mlm, idata=ABR.idata, idesign=~Type*Frequency,type="III")
summary(ABRtheta.aov,multivariate=F)
(theta_partial_omega_squared = (2-1)*(34.5733-1)/((2-1)*(34.5733-1)+(16*2*2)))

# Gamma relevant anova
ABRgamma = read.csv("ABRgamma_relevanTones.csv")  # read csv file; I added the header manually
ABRgamma.mat <- as.matrix(ABRgamma)
ABRgamma.mlm <- lm(ABRgamma.mat~1)
ABRgamma.aov <- Anova(ABRgamma.mlm, idata=ABR.idata, idesign=~Type*Frequency,type="III")
summary(ABRgamma.aov,multivariate=F)
(gamma_partial_omega_squared = (2 - 1)*(26.6484-1)/((2-1)*(26.6484-1)+(16*2*2)))