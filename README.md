
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

Each function in `bootEd` requires that the user specify the vector of data and a function to apply to the data. The function can be a base `R` function, such as `mean` or `median`, or a user-defined summary function. For example, to construct a bootstrap interval for the mean using the percentile method we use the following code:

```r
percentile(sample = rnorm(100, mean = 3, sd = 0.5), parameter = "mean")
```

And the output is:

![](unnamed-chunk-3-1.png)<!-- -->

```
## The percentile bootstrap interval for the mean is: (2.902389, 3.096528).
## 
## If it is reasonable to assume that the shifted sampling distribution of the 
## statistic of interest is symmetric and does not depend on any unknown parameters, 
## such as the underlying population variance, then this method can be used.
```

Each of the functions in the package returns the desired interval, its assumptions, and plots to check those assumptions.

In this case, the bootstrap distribution is symmetric, which makes the assumption about symmetry in the shifted sampling distribution reasonable. However, based on the Central Limit Theorem (CLT), the sampling distribution of the sample mean depends on the variance of the population. Therefore, the second assumption behind this interval is not met. Notice however, that it contains the population parameter. Our article goes further into what happens in the long run if we use this method incorrectly.

# Contributing

`bootEd` is released under the [following Code of Conduct](code_of_conduct.md). Please submit an issue for any questions and concerns.

# References 

Davison, A., & Hinkley, D. (1997). Bootstrap Methods and their Application (Cambridge Series in Statistical and Probabilistic Mathematics). Cambridge: Cambridge University Press. https://doi.org/10.1017/CBO9780511802843

Efron, B., & Tibshirani, R.J. (1994). An Introduction to the Bootstrap (1st ed.). Chapman and Hall/CRC. https://doi.org/10.1201/9780429246593

