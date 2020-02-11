write_files <- function(n, ngram_matrix) {
      
      suppressWarnings(suppressMessages(require("readr")))
      
      cat(paste0("Writing files.\n"))
      write_lines(ngram_matrix$names, paste0("ngrams/",n,"gram.txt"))
      write_lines(ngram_matrix$frequency, paste0("ngrams/",n,"gram_freq.txt"))
}