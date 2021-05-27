
\name{percentileMBI}

\alias{percentileMBI}

\title{Construct Percentile Bootstrap Intervals}

\description{Implements the percentile method for the construction of bootstrap intervals.}

\details{The percentile bootstrap interval method as outlined by Davison and Hinkley (1997) is used.}

\usage{
percentileMBI(sample, parameter, B = 999, siglevel = 0.05, onlyint = FALSE)
}

\arguments{
  \item{sample}{a vector of data which the user desires to bootstrap from}

  \item{parameter}{the name of a pre-defined (possibly user-written) function in quotes whose output is one value (e.g. mean, min, max, median)}

  \item{B}{number of bootstrap samples to obtain (defaults to 999 and must be less than 5000)}

  \item{siglevel}{the significance level desired for the construction of the bootstrap interval (defaults to 0.05)}

    \item{onlyint}{should the bootstrap interval alone be printed? (defaults to FALSE)}

}

\value{

If onlyint is set to FALSE, a histogram of the bootstrap sample statistics (with a line at the original observed sample statistic) and (or if onlyint is set to TRUE) the bootstrap interval with a statement about the assumptions and conditions of this method.
  
}

\author{
Njesa Totty
}

\examples{
percentileMBI(sample = rnorm(100), parameter = "mean", B = 999, siglevel = 0.05)

}

\references{Davison, Anthony Christopher, and David Victor Hinkley. 1997. \emph{Bootstrap Methods and Their Application}. Vol. 1. Cambridge university press.}
