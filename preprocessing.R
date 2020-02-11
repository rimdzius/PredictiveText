preprocessing <- function(n = c(2:10),
                          frequency_coverage = 1.0,
                          min_frequency = 2,
                          sample = 0.1,
                          rmv_stop = FALSE) {
   
   set.seed(1337)
   source("download_data.R")
   source("create_tokens.R")
   source("create_ngram_matrix.R")
   source("write_files.R")
   
   ## Download data, if required
   download_data()
   
   ## Read in Data, and create tokens:
   if (!exists("toks")){
      toks <- create_tokens(sample, rmv_stop)
   }
   
   ## iterate over n, create the matrices and then write them to files.
   for(i in n){
      cat(paste0("n=",i," ngram() starting...\n"))
      ngram_matrix <- create_ngram_matrix(i, toks, frequency_coverage, min_frequency)
      cat(paste0("n=",i," ngram() complete.\n"))
      write_files(i, ngram_matrix)
   }
   
   cat("\npreprocessing() complete.\n")
}