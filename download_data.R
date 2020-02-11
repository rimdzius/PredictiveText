download_data <- function() {
      
      if(!(file.exists("final/en_US/en_US.blogs.txt") &
           file.exists("final/en_US/en_US.news.txt") &
           file.exists("final/en_US/en_US.twitter.txt"))) {
            if(!file.exists("Coursera-SwiftKey.zip")) {
                  cat("Downloading data.\n")
                  url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
                  download.file(url, destfile = "Coursera-Swiftkey.zip")
            }
            cat("Unzipping data.\n")
            unzip("Coursera-SwiftKey.zip")
      }
}