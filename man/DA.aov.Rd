% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DA.aov.R
\name{DA.aov}
\alias{DA.aov}
\title{ANOVA}
\usage{
DA.aov(data, predictor, covars = NULL, relative = TRUE, p.adj = "fdr",
  allResults = FALSE, ...)
}
\arguments{
\item{data}{Either a matrix with counts/abundances, OR a \code{phyloseq} object. If a matrix/data.frame is provided rows should be taxa/genes/proteins and columns samples}

\item{predictor}{The predictor of interest. Factor, OR if \code{data} is a \code{phyloseq} object the name of the variable in \code{sample_data(data)} in quotation}

\item{covars}{Either a named list with covariables, OR if \code{data} is a \code{phyloseq} object a character vector with names of the variables in \code{sample_data(data)}}

\item{relative}{Logical. Should \code{data} be normalized to relative abundances. Default TRUE}

\item{p.adj}{Character. P-value adjustment. Default "fdr". See \code{p.adjust} for details}

\item{allResults}{If TRUE will return raw results from the \code{aov} function}

\item{...}{Additional arguments for the \code{aov} function}
}
\description{
Run ANOVA on multiple features with \code{predictor} as independent variable
}
