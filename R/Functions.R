
# ====================================================================================== #

percentileMBI <- function(sample, parameter, B = 999, siglevel = 0.05, onlyint = FALSE){


  # CREATE INITIAL BOOTSTRAP OBJECT

  # stopping clause to make sure the arguments are of the correct structure
  stopifnot(is.vector(sample))
  stopifnot(!is.list(sample))
  stopifnot(!is.expression(sample))
  stopifnot(is.character(parameter))
  stopifnot(exists(parameter))
  stopifnot(length(match.fun(parameter)(sample)) == 1)
  stopifnot(as.integer(B) == B)
  stopifnot(B <= 5000)
  stopifnot(siglevel > 0 & siglevel < 1)
  stopifnot(onlyint == FALSE | onlyint == TRUE)


  # drop NA's from original sample before bootstrapping
  sampleuse <- stats::na.omit(sample)

  # resample from the original sample (w/o NA's) 'B*length(sample)' times with replacement and then organize into a matrix with B columns
  # so each column is a bootstrap sample
  b <- matrix(sample(sampleuse, replace = TRUE, size = length(sampleuse)*B), ncol = B)

  # calculate the bootstrap sample statistics
  stats <- numeric(B)

  for(i in 1:B){
    stats[i] <- match.fun(parameter)(b[,i])
  }

  # calculate original sample statistic
  ogstat <- match.fun(parameter)(sampleuse)

  # IMPLEMENT PERCENTILE METHOD

  interval <- c(sort(stats)[(B +1 )*(siglevel/2)], sort(stats)[(B +1 )*(1-(siglevel/2))])

  # OUTPUT

  if(onlyint == TRUE){
    return(interval)
  }else{

    # return a histogram of bootstrap sample statistics
    hist(stats, main = paste("Distribution of bootstrap \nsample statistics:", parameter),
         xlab = paste(parameter, "of each bootstrap sample"))
    abline(v = ogstat, col = "red", lwd = 3)

    # print results of confidence interval
    cat("The percentile basic bootstrap interval for the", parameter, "is: ")
    cat("(", interval[1], ", ", interval[2], ").\n", sep = "")
    cat("\nIf it is not reasonable to assume that the sampling \ndistribution of the statistic of interest is symmetric \nthis method should not be used.")

  }

}

# ====================================================================================== #

basicMBI <- function(sample, parameter, B = 999, siglevel = 0.05, onlyint = FALSE){

  # CREATE INITIAL BOOTSTRAP OBJECT

  # stopping clause to make sure the arguments are of the correct structure
  stopifnot(is.vector(sample))
  stopifnot(!is.list(sample))
  stopifnot(!is.expression(sample))
  stopifnot(is.character(parameter))
  stopifnot(exists(parameter))
  stopifnot(length(match.fun(parameter)(sample)) == 1)
  stopifnot(as.integer(B) == B)
  stopifnot(B <= 5000)
  stopifnot(siglevel > 0 & siglevel < 1)
  stopifnot(onlyint == FALSE | onlyint == TRUE)

  # drop NA's from original sample before bootstrapping
  sampleuse <- stats::na.omit(sample)

  # resample from the original sample (w/o NA's) 'B*length(sample)' times with replacement and then organize into a matrix with B columns
  # so each column is a bootstrap sample
  b <- matrix(sample(sampleuse, replace = TRUE, size = length(sampleuse)*B), ncol = B)

  # calculate the bootstrap sample statistics
  stats <- numeric(B)

  for(i in 1:B){
    stats[i] <- match.fun(parameter)(b[,i])
  }

  # calculate original sample statistic
  ogstat <- match.fun(parameter)(sampleuse)

  # CONSTRUCT BASIC INTERVAL

  diffs <- sort(stats - ogstat)
  interval <- c(unname((2*ogstat) - sort(stats)[(B +1 )*(1 - siglevel/2)]), unname((2*ogstat) - sort(stats)[(B + 1 )*(siglevel/2)]))

  # OUTPUT

  if(onlyint == TRUE){
    return(interval)
  }else{

    # return a histogram of bootstrap sample statistics
    hist(stats, main = paste("Distribution of bootstrap \nsample statistics:", parameter),
         xlab = paste(parameter, "of each bootstrap sample"))
    abline(v = ogstat, col = "red", lwd = 3)

    # Plot histogram of differences
    hist(diffs, main = "Shifted Bootstrap Distribution", xlab = paste("bootstrap sample", parameter, "-", "original sample", parameter))

    # print out confidence intervals
    cat("The basic bootstrap interval for the", parameter, "is: ")
    cat("(", interval[1], ", ", interval[2], ").\n", sep = "")
    cat("\nIf there is a constraint on the values that the parameter \ncan take or a nonlinear transformation was applied to the \nparameter this method should not be used. \n \nIf the shifted sampling distribution differs significantly \nfrom the shifted bootstrap distribution in theory this \nmethod should not be used.")

  }

}

# ====================================================================================== #

studentizedMBI <- function(sample, parameter, B = 999, siglevel = 0.05, onlyint = FALSE, M = 25){

  # CREATE INITIAL BOOTSTRAP OBJECT

  # stopping clause to make sure the arguments are of the correct structure
  # stopping clause to make sure the arguments are of the correct structure
  stopifnot(is.vector(sample))
  stopifnot(!is.list(sample))
  stopifnot(!is.expression(sample))
  stopifnot(is.character(parameter))
  stopifnot(exists(parameter))
  stopifnot(length(match.fun(parameter)(sample)) == 1)
  stopifnot(as.integer(B) == B)
  stopifnot(B <= 5000)
  stopifnot(siglevel > 0 & siglevel < 1)
  stopifnot(onlyint == FALSE | onlyint == TRUE)
  stopifnot(M > 15 & M < 50)

  # drop NA's from original sample before bootstrapping
  sampleuse <- stats::na.omit(sample)

  # resample from the original sample (w/o NA's) 'B*length(sample)' times with replacement and then organize into a matrix with B columns
  # so each column is a bootstrap sample
  b <- matrix(sample(sampleuse, replace = TRUE, size = length(sampleuse)*B), ncol = B)

  # calculate the bootstrap sample statistics
  stats <- numeric(B)

  for(i in 1:B){
    stats[i] <- match.fun(parameter)(b[,i])
  }

  # calculate original sample statistic
  ogstat <- match.fun(parameter)(sampleuse)

  # IMPLEMENT STUDENTIZED METHOD

  # estimate for variance of sample statistic
  uppervar <- (1/(B - 1))*sum((stats - ogstat)^2)

  # estimate for variance of each bootstrap sample statistic using second level bootstrap
  lowervar <- numeric(B)
  for(i in 1:B){
    # sample from each bootstrap sample M times and obtain M second level bootstrap sample statistics
    slb <- matrix(sample(b[,i], replace = TRUE, size = length(b[,i])*M), ncol = M)
    slstats <- numeric(M)
    for(j in 1:M){
      slstats[j] <- match.fun(parameter)(slb[,j])
    }
    slogstat <- stats[i]
    # calculate variance of second level bootstrap sample statistics
    lowervar[i] <- (1/(M-1))*sum((slstats - slogstat)^2)
  }

  # distribution of mock z-statistics
  z <- (stats - ogstat)/sqrt(lowervar)

  # the interval
  interval <- c(ogstat - (sqrt(uppervar)*sort(z)[round((B + 1)*(1 - siglevel/2))]),
                ogstat - (sqrt(uppervar)*sort(z)[round((B + 1)*(siglevel/2))]))


  # OUTPUT

  if(onlyint == TRUE){
    return(interval)
  }else{

    # return a histogram of bootstrap sample statistics
    hist(stats, main = paste("Distribution of bootstrap \nsample statistics:", parameter),
         xlab = paste(parameter, "of each bootstrap sample"))
    abline(v = ogstat, col = "red", lwd = 3)

    # plot to check conditions
    plot(stats, sqrt(lowervar),
         main = "Bootstrap sample statistic vs. \nsecond level bootstrap sample standard error",
         xlab = paste(parameter), ylab = "SE", pch = 19)

    # print results
    cat("The studentized basic bootstrap interval for the", parameter, "is: ")
    cat("(", interval[1], ", ", interval[2], ").\n", sep = "")
    cat("Use the second plot returned to determine if it is reasonable to assume independence \nbetween the standard error and statistic of each bootstrap sample.")

  }

}

# ====================================================================================== #





