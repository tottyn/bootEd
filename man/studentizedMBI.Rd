\name{studentizedMBI}

\alias{studentizedMBI}

\title{Construct Studentized Bootstrap Intervals}

\description{Implements the studentized method for the construction of bootstrap intervals.}

\usage{
studentizedMBI(sample, parameter, B = 999, siglevel = 0.05, onlyint = FALSE, M = 25)
}

\arguments{
  \item{sample}{a vector of data which the user desires to bootstrap from}

  \item{parameter}{the name of a pre-defined (possibly user-written) function in quotes whose output is one value (e.g. mean, min, max, median)}

  \item{B}{number of bootstrap samples to obtain (defaults to 999 and must be less than 5000)}

  \item{siglevel}{the significance level desired for the construction of the bootstrap interval (defaults to 0.05)}

  \item{M}{the number of second level bootstraps (defaults to 25; must be between 15 and 50)}

  \item{onlyint}{should the bootstrap interval alone be printed? (defaults to FALSE)}

}

\details{The studentized bootstrap interval method as outlined by Davison and Hinkley (1997) is used.}

\value{

If \code{onlyint} is set to \code{FALSE} items returned are: a histogram of the bootstrap sample statistics (with a line at the original observed sample statistic), a scatterplot of the bootstrap sample statistics versus their corresponding estimated sample variances (using a second level bootstrap), and the bootstrap interval with a statement about the assumptions and conditions of this method.  

If \code{onlyint} is set to \code{TRUE}, only the bootstrap interval is printed.    
  
}

\author{
Njesa Totty
}

\examples{

studentizedMBI(sample = rnorm(100), parameter = "median", B = 999, siglevel = 0.05, M = 25)

}

\references{Davison, Anthony Christopher, and David Victor Hinkley. 1997. \emph{Bootstrap Methods and Their Application}. Vol. 1. Cambridge university press.}

