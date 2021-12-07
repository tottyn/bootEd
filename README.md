
# bootEd

`bootEd` was created for teaching simple bootstrap intervals to undergraduate students in introductory statistics courses. Specifically, this package was created so that teachers can emphasize the assumptions behind the percentile, basic, and studentized bootstrap intervals when teaching them. These methods are outlined by Davison, A., & Hinkley, D. (1997) and Efron, B., & Tibshirani, R.J. (1994).

# Installation

To install and load `bootEd`, use the following code:

```r
install.packages("devtools")
devtools::install_github("tottyn/bootEd")
library(bootEd)
```

# Usage

Each function in `bootEd` requires that the user specify the vector of data and a function to apply to the data. The function can be a base `R` or user-defined summary function, such as `mean`, `min`, or `median`. 

Suppose that we take a random sample of size 20 from an underlying Chi-squared distribution with three degrees of freedom (right-skewed) and we are interested in obtaining an interval estimate for the population mean.

```r
data <- rchisq(20, 3)
```

We can construct a 95% percentile bootstrap interval for the mean using the `percentile` function in `bootEd`:

```r
percentile(sample = data, parameter = "mean", B = 999, siglevel = 0.05, onlyint = FALSE)
```

![](bootdistmean.png)<!-- -->

```
## The percentile bootstrap interval for the mean is: (2.007853, 3.803945).

## If it is reasonable to assume that the shifted sampling distribution of the 
## statistic of interest is symmetric and does not depend on any unknown parameters, 
## such as the underlying population variance, then this method can be used.
```

The assumptions behind the percentile bootstrap interval are that the shifted distribution of the statistic of interest does not depend on any unknown parameters, such as the population variance, and that this distrbution is symmetric.

We can generate shifted sampling distributions using samples from Chi-squared distributions with varying degrees of freedom:

```r
library(ggplot2)

# set sample size
n <- 20

# empty data set to save results to
plotdat <- data.frame(sampmeans = numeric(10000*6), df = numeric(10000*6))

# generate 10,000 sample means from samples of size 20 from a Chi-square(k) distribution, as k varies
# --------------------------------
plotdat[1:10000,2] <- 1 # k - degrees of freedom
sampmat <- matrix(rchisq(10000*n, df = 1), ncol = 10000)
plotdat[1:10000,1] <- colMeans(sampmat)
# --------------------------------
plotdat[10001:20000,2] <- 2
sampmat <- matrix(rchisq(10000*n, df = 2), ncol = 10000)
plotdat[10001:20000,1] <- colMeans(sampmat)
# --------------------------------
plotdat[20001:30000,2] <- 3
sampmat <- matrix(rchisq(10000*n, df = 3), ncol = 10000)
plotdat[20001:30000,1] <- colMeans(sampmat)
# --------------------------------
plotdat[30001:40000,2] <- 4
sampmat <- matrix(rchisq(10000*n, df = 4), ncol = 10000)
plotdat[30001:40000,1] <- colMeans(sampmat)
# --------------------------------
plotdat[40001:50000,2] <- 6
sampmat <- matrix(rchisq(10000*n, df = 6), ncol = 10000)
plotdat[40001:50000,1] <- colMeans(sampmat)
# --------------------------------
plotdat[50001:60000,2] <- 10
sampmat <- matrix(rchisq(10000*n, df = 10), ncol = 10000)
plotdat[50001:60000,1] <- colMeans(sampmat)
# --------------------------------

# shift by the population mean
plotdat$shiftsampmeans <- plotdat$sampmeans - plotdat$df

# plot shifted sampling distributions
ggplot(plotdat) +
  geom_histogram(aes(shiftsampmeans), color = "gray20", fill = "gray80") +
  facet_wrap(~ df, labeller = label_both) +
  theme_bw() +
  labs(x = "Shifted sample means", y = "Frequency") +
  theme(panel.spacing.x = unit(0.75, "cm"), strip.background = element_rect(fill = "gray80"))
```


In this example, the bootstrap distribution is symmetric, however, it is known that the distribution of the sample mean depends on the variance of the population. Therefore, the assumptions of the percentile interval are not met and an alternative method should be used.

The functions can also be used for simulation purposes by setting the argument `onlyint = TRUE`. This will print only the bootstrap interval making it easy to check for containment. Take the following simulation for example. We obtain 1000 percentile bootstrap intervals for the population mean using samples of size 30 from a Binomial(10, 0.25) population. 950 of the confidence intervals should contain the true population mean which is 2.5. 

```r
contained <- logical(1000)

for(i in 1:1000){
  ci <- percentile(sample = rbinom(30, 10, 0.25), parameter = "mean", onlyint = TRUE)
  contained[i] <- ci[1] <= 2.5 & ci[2] >= 2.5
}

# number of intervals that capture the true parameter
sum(contained)
```

```
## [1] 945
```

```r
# coverage proportion
mean(contained)
```

```
## [1] 0.945
```

# Contributing

`bootEd` is released under the [following Code of Conduct](code_of_conduct.md). Please submit an issue for any questions and concerns.

# References 

Davison, A., & Hinkley, D. (1997). Bootstrap Methods and their Application (Cambridge Series in Statistical and Probabilistic Mathematics). Cambridge: Cambridge University Press. https://doi.org/10.1017/CBO9780511802843

Efron, B., & Tibshirani, R.J. (1994). An Introduction to the Bootstrap (1st ed.). Chapman and Hall/CRC. https://doi.org/10.1201/9780429246593

