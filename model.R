GetData <- function() {
  nflplaybyplay2015 <- read.csv("nflplaybyplay2015.csv", stringsAsFactors=FALSE)
  return(nflplaybyplay2015)
}

GetTeams <- function() {
  aux <- GetData()
  return(unique(aux$posteam))
}

BuildDataOffensiveType <- function(params) {
  nflplaybyplay2015 <- GetData()
  dataf <- nflplaybyplay2015[nflplaybyplay2015$qtr == params[2] 
                             & nflplaybyplay2015$posteam == params[1], c("PlayType", "Yards.Gained", "down")]
  dataf <- na.omit(dataf)
  dataf <- ddply(dataf, "PlayType", summarise, 
                 FirstDown = round(mean(`Yards.Gained`[down == 1]), 2),
                 SecondDown = round(mean(`Yards.Gained`[down == 2]), 2),
                 ThirdDown = round(mean(`Yards.Gained`[down == 3]), 2),
                 FourthDown = round(mean(`Yards.Gained`[down == 4]), 2))
  dataf[is.na(dataf)] = 0
  
  return(dataf)
} 


BuildMatrixForHeatMap <- function(params) {
  nflplaybyplay2015 <- GetData()
  network <- nflplaybyplay2015[nflplaybyplay2015$qtr == params[2], c("yrdline100", "Yards.Gained")]
  network <- na.omit(network)
  network <- aggregate(`Yards.Gained` ~ yrdline100, data = network, FUN = mean)
  colnames(network) <- c("yrdline100", "League")
  
  dataf <- nflplaybyplay2015[nflplaybyplay2015$qtr == params[2] 
                            & nflplaybyplay2015$posteam == params[1], c("yrdline100", "Yards.Gained")]
  
  dataf <- na.omit(dataf)
  dataf <- aggregate(`Yards.Gained` ~ yrdline100, data = dataf, FUN = mean)
  
  colnames(dataf) <- c("yrdline100", params[1])
  
  dataf <- merge(dataf, network, by ='yrdline100', all.x = TRUE)
  dataf <- as.matrix(dataf[ ,2:3])
  
  return(dataf)
  
}