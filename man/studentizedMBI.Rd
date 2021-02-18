\name{studentizedMBI}

\alias{studentizedMBI}

\title{Construct Student-ized Bootstrap Intervals}

\description{Implements the student-ized method for the construction of bootstrap intervals.}

\usage{
studentizedMBI(sample, parameter, B = 999, siglevel = 0.05, onlyint = FALSE, M = 25)
}

\arguments{
  \item{sample}{a numeric vector of data which the user desires to bootstrap from}

  \item{parameter}{the name of a pre-defined (possibly user-written) function in quotes whose output is one value (e.g. mean, min, max, median)}

  \item{B}{number of bootstrap samples to obtain (defaults to 999 and must be less than 5000)}

  \item{siglevel}{the significance level desired for the construction of the bootstrap interval (defaults to 0.05)}

  \item{M}{the number of second level bootstraps (defaults to 25; must be between 15 and 50)}

  \item{onlyint}{should the bootstrap interval alone be printed? (defaults to FALSE)}

}

\details{The student-ized bootstrap interval method as outlined by Davison and Hinkley (1997) is used.}

\value{

A histogram of the bootstrap sample statistics (with a line at the original observed sample statistic) and a plot of the bootstrap sample statistics versus their corresponding estimated sample variances (using a second level bootstrap) are plotted. An interval is given also with instructions on how to use the aforementioned plots to check the assumptions of this method.

}

\author{
Njesa Totty
}

\examples{

studentizedMBI(sample = rnorm(100), parameter = "median", B = 999, siglevel = 0.05, M = 25)

}

\references{Davison, Anthony Christopher, and David Victor Hinkley. 1997. \emph{Bootstrap Methods and Their Application}. Vol. 1. Cambridge university press.}

