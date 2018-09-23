library(car)
setwd('/Users/hectorOrozco/Desktop/binauralBeats/analysis/1-analogue_scales')
mental_relaxation = read.csv("BB_ESAS_MR.csv")  # read csv file 
absorption_depth = read.csv("BB_ESAS_AD.csv")  # read csv file 

## Mental Relaxation
# First we create the multivariate linear model
mr.mlm <- lm(cbind(Baseline, MBG, BBT, BBG, MBT) ~ 1, data = mental_relaxation)

# Next we inform R of the within-subject design. We create a factor that contains the within-subjects variables
conditions <- factor(x= c("Baseline", "MBG", "BBT", "BBG", "MBT"), ordered=FALSE)

# Do the actual ANOVA
mr.aov <- Anova(mr.mlm, idata=data.frame(conditions),idesign=~conditions,type = "III")
summary(mr.aov,multivariate=FALSE)


## Absorption Depth
# First we create the multivariate linear model
ad.mlm <- lm(cbind(Baseline, MBG, BBT, BBG, MBT) ~ 1, data = absorption_depth)

# Next we inform R of the within-subject design. We create a factor that contains the within-subjects variables
conditions <- factor(x= c("Baseline", "MBG", "BBT", "BBG", "MBT"), ordered=FALSE)

# Do the actual ANOVA
ad.aov <- Anova(ad.mlm, idata=data.frame(conditions),idesign=~conditions,type = "III")
summary(ad.aov,multivariate=FALSE)