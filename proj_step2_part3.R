# Example of what we're parsing here. Leave commented out.
#
# <?xml version="1.0"?>  
#   <doc xmlns:gml="http://www.opengis.net/gml">   
#     <state>    
#       <gml:name abbreviation="AL"> ALABAMA </gml:name>    
#       <county>     
#         <gml:name> Autauga County </gml:name>     
#         <gml:location>      
#           <gml:coord>       
#             <gml:X>  -86641472 </gml:X>       
#             <gml:Y>  32542207  </gml:Y>      
#           </gml:coord>     
#         </gml:location>    
#       </county>
#

library("XML", lib.loc="~/R/win-library/3.1")

doc = xmlParse("http://www.stat.berkeley.edu/users/nolan/data/Project2012/counties.gml")
root = xmlRoot(doc)

# Extract data from county XML node
process_county = function(county) {
  
  # Extract name of county's state
  state = xmlParent(county)
  state_name = xmlValue(state[[1]])
  
  # Extract county's name
  county_name = xmlValue(county[[1]])
  county_name = gsub("^\\s+|\\s+$", "", county_name)
  
  if (nchar(strsplit(county_name, " County")[[1]]) != nchar(county_name)) {
    county_name = strsplit(county_name, " County")[[1]]
  }
  
  # Extract x and y coordinates
  location = county[[2]]
  coord = location[[1]]
  x = xmlValue(coord[[1]])
  y = xmlValue(coord[[2]])
  
  data = c(state_name, county_name, x, y)
  
  # Trim leading and trailing whitespace
  data = gsub("^\\s+|\\s+$", "", data)
  
  # State name should be properly capitalized
  data[1] = paste(substring(data[1], 1, 1),
                  tolower(substring(data[1], 2, nchar(data[1]))),
                  sep="")
  
  return(data)
  
}

counties = xpathSApply(root,
                       "/doc/state/county",
                       process_county)

counties_matrix = matrix(counties, byrow=TRUE, nrow=ncol(counties))
counties_df = data.frame(counties_matrix)
names(counties_df) = c("State", "County", "X", "Y")
counties_df = counties_df[!grepl("[Cc]ity$", counties_df$County), ]
