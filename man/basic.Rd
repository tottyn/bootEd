
\name{basic}

\alias{basic}

\title{Construct Basic Bootstrap Intervals}

\description{Implements the basic bootstrap method to construct interval estimates.}

\usage{
basic(sample, parameter, B = 999, siglevel = 0.05, onlyint = FALSE)
}

\arguments{
  \item{sample}{a vector of data which the user desires to bootstrap from}

  \item{parameter}{the name of a pre-defined (possibly user-written) function in quotes whose output is one value (e.g. mean, min, max, median)}

  \item{B}{number of bootstrap samples to obtain (defaults to 999 and must be less than 5000)}

  \item{siglevel}{the significance level desired for the construction of the bootstrap interval (defaults to 0.05)}

    \item{onlyint}{should the bootstrap interval alone be printed? (defaults to FALSE)}

}

\value{

If onlyint is set to FALSE, a histogram of the bootstrap sample statistics, with a line at the observed sample statistic, and the bootstrap interval are returned.

If onlyint is set to TRUE, only the bootstrap interval is returned as a numeric vector.

}

\author{
Njesa Totty
}

\examples{
basic(sample = rnorm(100), parameter = "mean", B = 999, siglevel = 0.05)

}

\references{

Davison, A. C., & Hinkley, D. V. (1997). \emph{Bootstrap Methods and Their Application} (No. 1). Cambridge University Press.

Efron, B., & Tibshirani, R. J. (1994). \emph{An Introduction to The Bootstrap}. CRC Press.

}

