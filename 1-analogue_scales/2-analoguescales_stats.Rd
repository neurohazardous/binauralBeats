##################################################
## Project: Binaural Beats
## Script purpose: Statistical testing of the visual analogue scales 
## Author: Hector D Orozco Perez
## Contact: hector.dom.orozco@gmail.com
## License: GNU GPL v3
##################################################

# initialize data frames
library(car)
set.seed(99)
setwd('/Users/hectordorozcoperez/Desktop/binauralBeats/analysis/1-analogue_scales')
mental_relaxation = read.csv("BB_ESAS_MR.csv")  # read csv file 
absorption_depth = read.csv("BB_ESAS_AD.csv")  # read csv file 

## mental relaxation 
mr.mlm <- lm(cbind(Baseline, MBG, BBT, BBG, MBT) ~ 1, data = mental_relaxation)  # create multi linear model
conditions <- factor(x= c("Baseline", "MBG", "BBT", "BBG", "MBT"), ordered=FALSE)  # within subject design flag
mr.aov <- Anova(mr.mlm, idata=data.frame(conditions),idesign=~conditions,type = "III")
all_data <- summary(mr.aov,multivariate=FALSE)
original_F = all_data$univariate.tests[10]  # get actual F statistic

# Just to make sure, we check normality of data with the Shapiro test
shapiro.test(residuals(mr.mlm))

# some of the data in the project isn't normal, so to keep things consistent, we decided to do permutation tests all around
F_distribution <- vector(mode="double", length=1000)
for (i in 1:1000){
  shuffled_mr <- mental_relaxation  # permute data, but only the rows (within design)
  for (n in 1:nrow(mental_relaxation)){
    shuffled_mr[n,] <- sample(shuffled_mr[n,])
  }
  mr.mlm <- lm(cbind(Baseline, MBG, BBT, BBG, MBT) ~ 1, data = shuffled_mr)  # create multi linear model
  conditions <- factor(x= c("Baseline", "MBG", "BBT", "BBG", "MBT"), ordered=FALSE)  # within subject design flag
  mr.aov <- Anova(mr.mlm, idata=data.frame(conditions),idesign=~conditions,type = "III")
  all_data <- summary(mr.aov,multivariate=FALSE)
  F_distribution[i] = all_data$univariate.tests[10]  # get F statistic of permuted data
}
p_value_temp <- F_distribution > original_F
p_value <- length(p_value_temp[p_value_temp == TRUE]) / length(p_value_temp)

CI_lower = sort(F_distribution)[25]
CI_upper = sort(F_distribution)[975]


## absorption depth
ad.mlm <- lm(cbind(Baseline, MBG, BBT, BBG, MBT) ~ 1, data = absorption_depth)  # create multi linear model
conditions <- factor(x= c("Baseline", "MBG", "BBT", "BBG", "MBT"), ordered=FALSE)  # within subject design flag
ad.aov <- Anova(ad.mlm, idata=data.frame(conditions),idesign=~conditions,type = "III")
all_data <- summary(ad.aov,multivariate=FALSE)
original_F = all_data$univariate.tests[10]  # get actual F statistic

# Just to make sure, we check normality of data with the Shapiro test
shapiro.test(residuals(ad.mlm))

# some of the data in the project isn't normal, so to keep things consistent, we decided to do permutation tests all around
F_distribution <- vector(mode="double", length=1000)
for (i in 1:1000){
  shuffled_ad <- absorption_depth  # permute data, but only the rows (within design)
  for (n in 1:nrow(absorption_depth)){
    shuffled_ad[n,] <- sample(shuffled_ad[n,])
  }
  ad.mlm <- lm(cbind(Baseline, MBG, BBT, BBG, MBT) ~ 1, data = shuffled_ad)  # create multi linear model
  conditions <- factor(x= c("Baseline", "MBG", "BBT", "BBG", "MBT"), ordered=FALSE)  # within subject design flag
  ad.aov <- Anova(ad.mlm, idata=data.frame(conditions),idesign=~conditions,type = "III")
  all_data <- summary(ad.aov,multivariate=FALSE)
  F_distribution[i] = all_data$univariate.tests[10]  # get F statistic of permuted data
}
p_value_temp <- F_distribution > original_F
p_value <- length(p_value_temp[p_value_temp == TRUE]) / length(p_value_temp)
CI_lower = sort(F_distribution)[25]
CI_upper = sort(F_distribution)[975]