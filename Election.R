url_format = "http://www.stat.berkeley.edu/users/nolan/data/Project2012/countyVotes2012/xxx.xml"

states = scan(url("http://www.stat.berkeley.edu/users/nolan/data/Project2012/countyVotes2012/stateNames.txt"),
              what="character", sep=",")

states = states[which(states!="states")] #Remove states header 
states = states[which(states!="alaska")] #Alaska is missing.

XML_files = c()
  
for (i in seq(length(states))) {
  target = sub("xxx", states[i], url_format)
  XML_files = c(XML_files, xmlParse(target, isURL=TRUE))
}
