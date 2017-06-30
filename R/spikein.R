#' Spike-in
#'
#' Modified version of the one from:
#' https://microbiomejournal.biomedcentral.com/articles/10.1186/s40168-016-0208-8

#' @export

spikein <- function(count_table, outcome, spikeMethod = "mult", effectSize = 2, k, relative = TRUE){
  
  if(relative == FALSE & spikeMethod == "mult") stop("Cannot use multiplicative spike-in if relative is FALSE")
  
  if(effectSize == 1) spikeMethod <- "none"

  count_table <- as.data.frame(count_table)
  outcome <- as.numeric(as.factor(outcome))-1
  
  # Choose Features to spike
  propcount <- apply(count_table,2,function(x) x/sum(x))
  count_abundances <- sort(rowSums(propcount)/ncol(propcount))

  # Only spike Features present in cases
  approved_count_abundances <- count_abundances[ 
    names(count_abundances) %in% row.names( count_table[ rowSums(count_table[,outcome == 1]) > 0, outcome == 1] ) ]
  lower_tert <- names(approved_count_abundances[approved_count_abundances < quantile(approved_count_abundances,1/3)])
  mid_tert <- names(approved_count_abundances[approved_count_abundances >= quantile(approved_count_abundances,1/3) & approved_count_abundances < quantile(approved_count_abundances,2/3)])
  upper_tert <- names(approved_count_abundances[approved_count_abundances >= quantile(approved_count_abundances,2/3)])
  spike_features <- c( 	sample(lower_tert, k)	,
                     sample(mid_tert, k)		,
                     sample(upper_tert,k)	)
  spike_feature_index <- which(row.names(count_table) %in% spike_features)
  
  # Spike Features either by addition or multiplication
  oldSums <- colSums(count_table)

  if(spikeMethod == "mult"){
    count_table[spike_feature_index,outcome==1] <- count_table[spike_feature_index, outcome==1] * effectSize
  }
  
  
  
  if(spikeMethod == "add"){
    nonzeroMeans <- lapply(spike_feature_index, function(j){
      v <- propcount[j,]
      v <- v[v != 0]
      mean(v)
    })
    cases <- count_table[,outcome == 1]
    caseDepth <- colSums(cases)
    addlist <- lapply(nonzeroMeans, function(l) l*caseDepth*effectSize)
    addcounts <- do.call(rbind, addlist)
    addcounts[cases[spike_feature_index,] == 0] <- 0
    cases[spike_feature_index,] <- cases[spike_feature_index,]+addcounts
    count_table[,outcome == 1] <- cases	
  }
  
  newSums <- colSums(count_table)
  if(relative) count_table <- round(t(t(count_table) * oldSums/newSums))
  list(count_table,spike_features)
  
}