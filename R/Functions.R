
# ====================================================================================== #

percentile <- function(sample, parameter, B = 999, siglevel = 0.05, onlyint = FALSE){


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
         xlab = paste("bootstrap", parameter))
    abline(v = ogstat, col = "red", lwd = 3)

    # print results of confidence interval
    cat("The percentile bootstrap interval for the", parameter, "is: ")
    cat("(", interval[1], ", ", interval[2], ").\n", sep = "")
    cat("\nIf it is reasonable to assume that the shifted sampling distribution of the \nstatistic of interest is symmetric and does not depend on any unknown parameters, \nsuch as the underlying population variance, then this method can be used.")

  }

}

# ====================================================================================== #

basic <- function(sample, parameter, B = 999, siglevel = 0.05, onlyint = FALSE){

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
         xlab = paste("bootstrap", parameter))
    abline(v = ogstat, col = "red", lwd = 3)

    # print out confidence intervals
    cat("The basic bootstrap interval for the", parameter, "is: ")
    cat("(", interval[1], ", ", interval[2], ").\n", sep = "")
    cat("\nIf it is reasonable to assume that the shifted sampling distribution of the \nstatistic of interest does not depend on any unknown parameters, \nsuch as the underlying population variance, then this method can be used.")

  }

}

# ====================================================================================== #

studentized <- function(sample, parameter, B = 999, siglevel = 0.05, onlyint = FALSE, M = 25){

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
  uppervar <- (1/(B - 1))*sum((stats - mean(stats))^2)

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
    lowervar[i] <- (1/(M-1))*sum((slstats - mean(slstats))^2)
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
         xlab = paste("bootstrap", parameter))
    abline(v = ogstat, col = "red", lwd = 3)

    # and studentized bootstrap distribution
    hist(z, main = "Studentized bootstrap distribution",
         xlab = paste("studentized", parameter), pch = 19)

    # print results
    cat("The studentized bootstrap interval for the", parameter, "is: ")
    cat("(", interval[1], ", ", interval[2], ").\n", sep = "")
    cat("\nIf it is reasonable to assume that the studentized sampling distribution of the \nstatistic of interest does not depend on any unknown parameters, \nthen this method can be used.")

  }

}

# ====================================================================================== #





