#' Linear regression - log
#'
#' @export

DA.llm <- function(count_table, outcome, paired = NULL, p.adj, delta = 1){
 
  count_table <- as.data.frame.matrix(count_table)
  count_table <- log(count_table + delta)
  count.rel <- apply(count_table,2,function(x) x/sum(x))
  
  if(is.null(paired)){
    lmr <- function(x){
      fit <- NULL
      tryCatch(
        fit <- lm(x ~ outcome), 
        error = function(x) fit <- NULL)
      if(!is.null(fit)) {
        if(nrow(coef(summary(fit))) > 1) {
          coef(summary(fit))[2,]
        } else NA
      } else NA 
    }
  } else {
    lmr <- function(x){
      fit <- NULL
      tryCatch(
        fit <- lme(x ~ outcome, random = ~1|paired), 
        error = function(x) fit <- NULL)
      if(!is.null(fit)) {
        if(nrow(coef(summary(fit))) > 1) {
          coef(summary(fit))[2,c(1,2,4,5)]
        } else NA
      } else NA 
    }
  }
  
  res <- as.data.frame(t(as.data.frame(apply(count.rel,1,lmr))))
  colnames(res) <- c("Estimate","Std.Error","t-value","pval")
  res$pval.adj <- p.adjust(res$pval, method = p.adj)
  res$Feature <- rownames(res)
  res$Method <- "Linear regression - Log"
  return(res)
  
}