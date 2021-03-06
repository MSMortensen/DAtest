% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/groupSig.R
\name{groupSig}
\alias{groupSig}
\title{Are some groups/taxa overrepresented among significant features}
\usage{
groupSig(results, group.df, group.cols = 1, split = TRUE, alpha = 0.05,
  p.adj = "fdr", alternative = "greater")
}
\arguments{
\item{results}{Data.frame with results from a \code{DAtest} function}

\item{group.df}{Data.frame with columns defining the groups. rownames should name the features matching the \code{Feature} column in \code{results}. E.g. \code{tax_table} from a \code{phyloseq} object}

\item{group.cols}{Numeric vector defining which column(s) contain(s) the groups in \code{group.df}. Default first column.}

\item{split}{If TRUE will split tests in positive and negative effect sizes if possible. Default TRUE}

\item{alpha}{Threshold for significance calling. Default 0.05}

\item{p.adj}{Method for p-value adjustment. Default "fdr"}

\item{alternative}{What to test for. "greater" (default) is testing only overrepresentation (OR > 1), "less" only underrepresentation (OR < 1), and "two.sided" tests over- and under-representation (OR != 1)}
}
\value{
A data.frame with odds ratios (OR), p-values, adjusted p-values, groups, name of groups, and direction of effect if split = TRUE
}
\description{
Test if some groups of features are overpresented among significant features. 
The groups can be anything; for OTU data e.g. genera/family/order/class/phylum, for transciptomics e.g. KEGG pathway.
}
\details{
OR in output is odds ratio from fisher's exact test. If OR is above 1 it means that the group is overrepresented among significant features.
}
