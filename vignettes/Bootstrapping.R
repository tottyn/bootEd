## ----setup, include = FALSE---------------------------------------------------

knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#",
  echo = TRUE,
  error = FALSE,
  message = FALSE,
  warning = FALSE,
  fig.width = 5,
  fig.height = 4
)

library(devtools)
load_all()


## ---- eval = FALSE------------------------------------------------------------
#  
#  # install devtools in order to use the install_github function (skip if you already have it, comment out once installed)
#  install.packages(devtools)
#  
#  # load devtools
#  library(devtools)
#  
#  # install bootEd from GitHub
#  install_github("tottyn/bootEd")
#  
#  # load bootEd
#  library(bootEd)
#  

## -----------------------------------------------------------------------------

# uncomment the lines of code below to install the babynames package
#install.packages("babynames")

# load the package
library(babynames)

# load the babynames dataset
data("babynames")

# view the documentation for the dataset (uncomment first)
# ?babynames

# view the first six lines of the babynames dataset
head(babynames)


## -----------------------------------------------------------------------------

babynames <- rbind(read.csv(system.file("extdata", "babynames1.csv", package = "bootEd")),
                   read.csv(system.file("extdata", "babynames2.csv", package = "bootEd")),
                   read.csv(system.file("extdata", "babynames3.csv", package = "bootEd")),
                   read.csv(system.file("extdata", "babynames4.csv", package = "bootEd"))
                   )


## -----------------------------------------------------------------------------

# subset the entire dataset to only those observations that occured in the year 2012
babies2012 <- babynames[babynames$year == "2012", ]


## -----------------------------------------------------------------------------

# determine how many babies total were born in 2012 - this should match the number of rows of the resulting dataset
sum(babies2012$n)

# repeat the index for each row of the dataset n times, where n is different for each row and is given by the variable n
indices <- rep(1:nrow(babies2012), babies2012$n)

# create expanded dataset and drop the columns that contain n (column 4) and prop (column 5)
babies2012expanded <- babies2012[indices,-c(4,5)]

# check that number of rows of expanded dataset matches number of babies born in 2012 found earlier
nrow(babies2012expanded)


## -----------------------------------------------------------------------------

# be sure to run this to get the same results
set.seed(8120)

# generate a random sample of 35 indices
sampindices <- sample(1:nrow(babies2012expanded), 35, replace = FALSE)

# subset the dataset using the random sample of indices
babies2012sample <- babies2012expanded[sampindices,]

# view the first six rows of the sample data
head(babies2012sample)


## -----------------------------------------------------------------------------

# total number of female babies in sample divided by total number of babies in sample
sum(babies2012sample$sex == "F")/length(babies2012sample$sex)


## -----------------------------------------------------------------------------

# create an empty vector of length 1000 to save the proportions to
babyprops <- numeric(1000)

for(i in 1:1000){ # repeat 1000 times and save each time
  
  # generate a random sample of 35 indices
  sampindices_loop <- sample(1:nrow(babies2012expanded), 35, replace = FALSE)
  
  # subset the dataset using the random sample of indices
  babies2012sample_loop <- babies2012expanded[sampindices_loop,]
  
  # total number of female babies in sample divided by total number of babies in sample
  babyprops[i] <- sum(babies2012sample_loop$sex == "F")/length(babies2012sample_loop$sex)
  
}


## -----------------------------------------------------------------------------

# calculate the population proportion and save

pop_prop <- sum(babies2012expanded$sex == "F")/length(babies2012expanded$sex)

# create the histrogram
hist(babyprops, main = "Sampling Distribution", xlab = "Sample Proportions")

# add a vertical line at the population proportion for reference
abline(v = pop_prop, col = "red", lwd = 2)


## -----------------------------------------------------------------------------

# creating a function that calculates the proportion of females
proportion <- function(x){
  sum(x == "F")/length(x)
}

# checking the function - this should be 0.8
test <- c("F", "F", "F", "F", "M")
proportion(test)


## ---- include = FALSE---------------------------------------------------------

set.seed(340)


## -----------------------------------------------------------------------------
# bootstrap interval using the percentile method and original sample taken
basicMBI(sample = babies2012sample$sex, parameter = "proportion", B = 999, siglevel = 0.05)


## -----------------------------------------------------------------------------

# create the histrogram of the shifted sample proportions
hist(babyprops - pop_prop, main = "Shifted Sampling Distribution", xlab = "Sample Proportions - Population proportion")


## -----------------------------------------------------------------------------

percentileMBI(sample = babies2012sample$sex, parameter = "proportion", B = 999, siglevel = 0.05)


## -----------------------------------------------------------------------------

studentizedMBI(sample = babies2012sample$sex, parameter = "proportion", B = 999, siglevel = 0.05)


## -----------------------------------------------------------------------------

# generate 1000 samples of size 40 from an Exp(2) distribution
expmat <- matrix(rexp(40*1000, 2), nrow = 40, ncol = 1000)

# find the variance of each sample (each column)
exp_vars <- apply(expmat, 2, var)

# plot the sampling distribution of sample variance (approximate sampling distribution)
hist(exp_vars, xlab = "Sample Variance", main = "Sampling Distribution")


## -----------------------------------------------------------------------------

# use just one of the 1000 samples of size 40 from an Exp(2) population
samp <- expmat[, 30]

# construct a percentile bootstrap interval from that one sample
percentileMBI(sample = samp, parameter = "var", B = 999, siglevel = 0.05)


## -----------------------------------------------------------------------------

# create a logical vector to store the results of the loop in
contained <- logical(1000)

for(i in 1:1000){ # repeat 1000 times and save each time
  
  # set the working sample as the ith column of the matrix that had 1000 samples
  samp_loop <- expmat[,i]
  
  # construct an interval using that sample
  interval <- percentileMBI(sample = samp_loop, parameter = "var", B = 999, 
                            siglevel = 0.05, onlyint = TRUE)
  
  # check that 0.25 is within the bounds of the interval - if so this returns TRUE or else it returns FALSE
  contained[i] <- interval[1] <= 0.25 & interval[2] >= 0.25
  
}

# determine the proportion of intervals that contained the true parameter - that is, the proportion of TRUE's
mean(contained)


