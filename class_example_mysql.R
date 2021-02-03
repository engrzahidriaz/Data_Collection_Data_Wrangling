

############################# MySQL ######################

library('RMySQL')

######## RSQL Configured ##########

ucscDb <- dbConnect(MySQL(),user="genome",host="genome-mysql.cse.ucsc.edu")

result <- dbGetQuery(ucscDb, "show databases;"); dbDisconnect(ucscDb)

result

######### Connecting to a Database ##########

hg19 <- dbConnect(MySQL(),user="genome", db = "hg19", host="genome-mysql.cse.ucsc.edu")
AllTable <- dbListTables(hg19)
length(AllTable)

AllTable[1:5]

########## Run A Query Using dbGetQuery()Command ###########

dbListFields(hg19, "affyU133Plus2")         #all field in list of table

dbGetQuery(hg19, "select count(*) from affyU133Plus2")     # No. of rows

########### Read from Table ##########

affyData <- dbReadTable(hg19, "affyU133Plus2")        # read all table
head(affyData)                                        # first five rows

############# Select a Specific Subset ##############3

query <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3")
affyMis <- fetch(query); quantile(affyMis$misMatches)

affyMisSmall <- fetch(query, n=10); dbClearResult(query)

dim(affyMisSmall)

dbDisconnect(hd19)
