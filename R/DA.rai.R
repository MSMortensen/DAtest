#' RAIDA
#' @param data Either a matrix with counts/abundances, OR a phyloseq object. If a matrix/data.frame is provided rows should be taxa/genes/proteins and columns samples
#' @param outcome The outcome of interest. Either a Factor or Numeric, OR if data is a phyloseq object the name of the variable in sample_data in quotation
#' @param p.adj Character. P-value adjustment. Default "fdr". See p.adjust for details
#' @param ... Additional arguments for the raida function
#' @export

DA.rai <- function(data, outcome, p.adj = "fdr", ...){
  
  library(RAIDA)
  
  # Extract from phyloseq
  if(class(data) == "phyloseq"){
    if(length(outcome) > 1) stop("When data is a phyloseq object outcome should only contain the name of the variables in sample_data")
    if(!outcome %in% sample_variables(data)) stop(paste(outcome,"is not present in sample_data(data)"))
    count_table <- otu_table(data)
    if(!taxa_are_rows(data)) count_table <- t(count_table)
    outcome <- suppressWarnings(as.matrix(sample_data(data)[,outcome]))
  } else {
    count_table <- data
  }
  
  count_table.o <- as.data.frame(count_table[,order(outcome)])
  
  res <- raida(count_table.o, n.lib = as.numeric(table(outcome)), mtcm = p.adj, ...)
  res$Feature <- rownames(res)
  colnames(res)[1] <- "pval"
  colnames(res)[2] <- "pval.adj"
  res$Method <- "RAIDA" 
  
  if(class(data) == "phyloseq"){
    if(!is.null(tax_table(data, errorIfNULL = FALSE))){
      tax <- tax_table(data)
      res <- merge(res, tax, by.x = "Feature", by.y = "row.names")
      rownames(res) <- NULL
    } 
  }
  
  return(res)

}



