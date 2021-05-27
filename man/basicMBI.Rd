\name{basicMBI}

\alias{basicMBI}

\title{Construct Basic Bootstrap Intervals}

\description{Implements the basic method for the construction of bootstrap intervals.}

\usage{
basicMBI(sample, parameter, B = 999, siglevel = 0.05, onlyint = FALSE)
}

\arguments{
  \item{sample}{a vector of data which the user desires to bootstrap from}

  \item{parameter}{the name of a pre-defined (possibly user-written) function in quotes whose output is one value (e.g. mean, min, max, median)}

  \item{B}{number of bootstrap samples to obtain (defaults to 999 and must be less than 5000)}

  \item{siglevel}{the significance level desired for the construction of the bootstrap interval (defaults to 0.05)}

    \item{onlyint}{should the bootstrap interval alone be printed? (defaults to FALSE)}

}

\value{

If \code{onlyint} is set to \code{FALSE}, a histogram of the bootstrap sample statistics (with a line at the original observed sample statistic), a histogram of the bootstrap sample statistics shifted by the original sample statistic, and the bootstrap interval with a statement about the assumptions and conditions of this method.

If `onlyint` is set to `TRUE`, just the bootstrap interval is printed.   
  
}

\author{
Njesa Totty
}

\examples{
basicMBI(sample = rnorm(100), parameter = "median", B = 999, siglevel = 0.05)
}

\references{Davison, Anthony Christopher, and David Victor Hinkley. 1997. \emph{Bootstrap Methods and Their Application}. Vol. 1. Cambridge university press.}

\details{The basic bootstrap interval method as outlined by Davison and Hinkley (1997) is used.}
