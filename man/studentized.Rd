\name{studentized}

\alias{studentized}

\title{Construct Studentized Bootstrap Intervals}

\description{Implements the studentized bootstrap method to construct interval estimates.}

\usage{
studentized(sample, parameter, B = 999, siglevel = 0.05, onlyint = FALSE, M = 25)
}

\arguments{
  \item{sample}{a vector of data which the user desires to bootstrap from}

  \item{parameter}{the name of a pre-defined (possibly user-written) function in quotes whose output is one value (e.g. mean, min, max, median)}

  \item{B}{number of bootstrap samples to obtain (defaults to 999 and must be less than 5000)}

  \item{siglevel}{the significance level desired for the construction of the bootstrap interval (defaults to 0.05)}

  \item{M}{the number of second level bootstraps (defaults to 25; must be between 15 and 50)}

  \item{onlyint}{should the bootstrap interval alone be printed? (defaults to FALSE)}

}

\value{

If onlyint is set to FALSE, (1) a histogram of the bootstrap sample statistics, with a line at the observed sample statistic, (2) a histogram of the studentized bootstrap sample statistics, and (3) the bootstrap interval are all returned.

If onlyint is set to TRUE, only the bootstrap interval is returned as a numeric vector.

}

\author{
Njesa Totty
}

\examples{

studentized(sample = rnorm(100), parameter = "median", B = 999, siglevel = 0.05, M = 25)

}

\references{

Davison, A. C., & Hinkley, D. V. (1997). \emph{Bootstrap Methods and Their Application} (No. 1). Cambridge University Press.

Efron, B., & Tibshirani, R. J. (1994). \emph{An Introduction to The Bootstrap}. CRC Press.

}




