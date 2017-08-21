DAtest
======

This is a package for comparing different differential abundance methods
used in microbial marker-gene (e.g. 16S rRNA), RNA-seq and protein
abundance analysis.

The methodology goes as follows:

-   Shuffle predictor variable
-   Spike in data for some randomly chosen features, such that they are
    associated with the shuffled predictor
-   Apply methods, and check:
    -   whether they can find the spike-ins
    -   whether the false positive rate is controlled

Many scripts, including the spike-in for estimating AUC, is borrowed
from: [Thorsen J, Brejnrod A et al. Large-scale benchmarking reveals
false discoveries and count transformation sensitivity in 16S rRNA gene
amplicon data analysis methods used in microbiome studies. *Microbiome*
(2016)](https://microbiomejournal.biomedcentral.com/articles/10.1186/s40168-016-0208-8)

Installation of packages
------------------------

    library(devtools)
    install_github("Russel88/DAtest")

#### The following are needed for *full* functionality

But the package will work without them

    source("https://bioconductor.org/biocLite.R")
    biocLite("DESeq2")
    biocLite("edgeR")
    biocLite("metagenomeSeq")
    biocLite("baySeq")
    biocLite("ALDEx2")
    biocLite("limma")

ANCOM has to be installed from an [external
source.](https://www.niehs.nih.gov/research/resources/software/biostatistics/ancom/index.cfm)

How to compare methods:
-----------------------

A good method has a "False Positive Rate" (FPR) at ~0.05 or below, an
"Area Under the (Receiver Operator) Curve" (AUC) as high as possible,
and a "Spike Detection Rate" (Spike.detect.rate) as high as possible.

**Run the test:**

    mytest <- testDA(count_table,predictor)

count\_table is a matrix or data.frame with taxa/genes/proteins as rows
and samples as columns.

predictor is the outcome of interest, e.g. a factor denoting whether
samples are cases or controls (in the same order as columns in
count\_table).

predictor can be a factor with more than two levels, in which case only
the second level is spiked, and if methods output several p-values, only
the p-value associated with the second level is used.

predictor can also be numeric, in which case it is spiked as followed:
newAbundances = oldAbundances \* (effectSize ^ predictor/sum(predictor))

*The tests can be run in a paired version:*

E.g. if SubjectID is a factor denoting the pairing of the samples (in
the same order as columns in the count\_table):

    mytest <- testDA(count_table,predictor,paired=SubjectID)

When a *paired* argument is provided, the predictor is shuffled within
the levels of the *paired* factor.

*Or without relative abundances, e.g. for normalized protein abundance:*

    mytest <- testDA(count_table,predictor,relative=FALSE,spikeMethod="add",tests=c("ttt","lim","wil","per"),testStat = function(case,control) {mean(case)-mean(control)})

**Plot the output:**

    plot(mytest, sort = "AUC")

Plot the p-value distributions. Raw p-values should have a uniform
(flat) distribution between 0 and 1. If adj = TRUE, adjusted p-values
will be plotted, and there should not be any below 0.05 (assuming an
alpha = 0.05).

    plot(mytest, p = TRUE)

**Print the output:**

Medians for each method:

    summary(mytest, sort = "AUC")

Results from all the runs:

    print(mytest)

How to run real data:
---------------------

All tests can easily be run with the original data. E.g. edgeR exact
test:

    res.ere <- DA.ere(count_table,predictor)

All methods can be accessed in the same way; DA."test" where "test" is
the abbreviation given in the details of the testDA function.

Alternatively, run all (or several) methods and check which features are
found by several methods

    res.all <- allDA(count_table,predictor)

    head(res.all$table)

Implemented methods:
--------------------

-   per - [Permutation test with user defined test
    statistic](https://microbiomejournal.biomedcentral.com/articles/10.1186/s40168-016-0208-8)
    (See below for description of the paired permutation test)
-   bay -
    [baySeq](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-11-422)
-   adx - [ALDEx t-test and
    wilcoxon](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0067019)
-   wil - Wilcoxon Rank Sum on relative abundances
-   ttt - Welch t.test on relative abundances
-   ltt - Welch t.test, but reads are first transformed with
    log(abundance + delta) then turned into relative abundances
-   ltt2 - Welch t.test, but with relative abundances transformed with
    log(relative abundance + delta)
-   neb - Negative binomial GLM with log of library size as offset (The
    paired version is a mixed-effect model)
-   erq - [EdgeR - Quasi
    likelihood](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2796818/)
    (The paired version is a model with the paired variable
    as covariate)
-   ere - [EdgeR - Exact
    test](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2796818/)
-   msf - [MetagenomeSeq feature
    model](https://bioconductor.org/packages/release/bioc/html/metagenomeSeq.html)
-   zig - [MetagenomeSeq zero-inflated
    gaussian](https://www.nature.com/nmeth/journal/v10/n12/full/nmeth.2658.html)
-   ds2 -
    [DESeq2](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-014-0550-8)
    (The paired version is a model with the paired variable
    as covariate)
-   enn - [ENNB](https://cals.arizona.edu/~anling/software.htm)
-   anc - [ANCOM](https://www.ncbi.nlm.nih.gov/pubmed/26028277)
-   lim -
    [LIMMA](https://link.springer.com/chapter/10.1007%2F0-387-29362-0_23?LI=true)
-   kru - Kruskal-Wallis test on relative abundances
-   aov - ANOVA on relative abundances
-   lao - ANOVA, but reads are first transformed with log(abundance +
    delta) then turned into relative abundances
-   lao2 - ANOVA, but with relative abundances transformed with
    log(relative abundance + delta)
-   lrm - Linear regression on relative abundances
-   llm - Linear regression, but reads are first transformed with
    log(abundance + delta) then turned into relative abundances
-   llm2 - Linear regression, but with relative abundances transformed
    with log(relative abundance + delta)

### Paired permutation test

A paired permutation test is implemented specifically for this package.
The test is similar to the original, but with a different test statistic
and permutation scheme. The permutations are constrained in the paired
version such that the outcome is only permuted within each level of the
paired argument (e.g. subjects). The test statistic first finds the
log-ratio between the two outcome levels (e.g. case and control) for
each level of the paired argument and the final statistic is the mean of
these log-ratios.
