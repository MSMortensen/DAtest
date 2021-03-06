% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DA.lao2.R
\name{DA.lao2}
\alias{DA.lao2}
\title{ANOVA}
\usage{
DA.lao2(data, predictor, covars = NULL, p.adj = "fdr", delta = 0.001,
  allResults = FALSE, ...)
}
\arguments{
\item{data}{Either a matrix with counts/abundances, OR a \code{phyloseq} object. If a matrix/data.frame is provided rows should be taxa/genes/proteins and columns samples}

\item{predictor}{The predictor of interest. Factor, OR if \code{data} is a \code{phyloseq} object the name of the variable in \code{sample_data(data)} in quotation}

\item{covars}{Either a named list with covariables, OR if \code{data} is a \code{phyloseq} object a character vector with names of the variables in \code{sample_data(data)}}

\item{p.adj}{Character. P-value adjustment. Default "fdr". See \code{p.adjust} for details}

\item{delta}{Numeric. Pseudocount for the log transformation. Default 0.001}

\item{allResults}{If TRUE will return raw results from the \code{aov} function}

\item{...}{Additional arguments for the \code{aov} functions}
}
\description{
Apply ANOVA to multiple features with one \code{predictor}, with log transformation of relative abundances.
}
