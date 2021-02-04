
################################################
############### Check Directory ################
################################################
if (!file.exists("data")) {
  dir.create("data")
}

setwd('./data')
setwd('../')


################################################
################ Download Files ################
################################################

fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"

download.file(fileUrl, destfile = "cameras.csv")
list.files("./data")

cdata <- read.table('./data/cameras.csv', sep = ',', header = TRUE)

cameradata <- read.csv('./data/cameras.csv')
# structure of data 
str(cameradata)


################################################
############ Read xlsx data file ###############
################################################
# To write xlsx data file
library(readxl)
readxl_example()

xlsx_example <- readxl_example("type-me.xls")
#file read
diris = read_excel(xlsx_example)

dd <- read_excel("./data/cameras.xlsx")

# Exercise: Try examples
?read_excel 

# To write xlsx data file
devtools::install_github("ropensci/writexl")

library(writexl)
write_xlsx(cdata, "./data/cameras.xlsx")


#############################################
############## HTML webpage #################
#############################################
#Read HTML webpage
library(rvest)

theurl <- "http://en.wikipedia.org/wiki/Brazil_national_football_team"
theurl
file <- read_html(theurl)

#Read Table from webpage
tables<-html_nodes(file, "table")
table1 <- html_table(tables[4], fill = TRUE)

?html_text


#############################################
################ Data Table #################
#############################################
library(data.table)
DF = data.frame(x=rnorm(9), y=rep(c("a", "b", "c"), each=3), z=rnorm(9))
head(DF, 3)

DT = data.table(x=rnorm(18), y=rep(c("a", "b", "c"), each=3), z=rnorm(18))
head(DT, 3)

tables()

DT[,list(mean(x), sum(z))]
DT[,table(y)]

DT[,w:=z^2]
DT[,a:=x>0]

?data.table::fsort

x = runif(1e6)
system.time(ans1 <- sort(x, method="quick"))
system.time(ans2 <- fsort(x))
identical(ans1, ans2)

##################################################
############## Sub-setting and Sorting  ##########
##################################################

set.seed(13435)            # same result for ramdom values
x <- data.frame("var1"=sample(1:5),"var2"=sample(6:10), "var3"=sample(11:15))
x <- x[sample(1:5),];x$var2[c(1,3),] =NA
x
x[,1]
x[,'var1']
x[1:2,'var2']
x[x$var1 <= 3 & x$var3 > 11,]    # AND operation
x[x$var1 <= 3 | x$var3 > 15,]    # OR operation

#Sorting
sort(x$var1)
sort(x$var1,decreasing = TRUE)
sort(x$var2,n.last = TRUE)

#order in data frame
X[order(x$var1),]
X[order(x$var1, x$var3),]


##################################################
####### Dealing with Missing/Null Values  #######
##################################################

# Test for Missing Values
x <- c(1:4, NA, 6:7, NA)
is.na(x)

df<- data.frame(col1 = c(1:3, NA), col2 = c("this", NA,"is", "text"),
                col3 = c(TRUE, FALSE, TRUE, TRUE), col4 = c(2.5, 4.2, 3.2, NA), stringsAsFactors = FALSE)
df
is.na(df)

is.na(df$col4)                   # identify NAs in specific data frame column
which(is.na(x))                  # identify location of NAs in vector
sum(is.na(df))                   # identify count of NAs in data frame
colSums(is.na(df))              # identify complete NAs in each Column

# Recode/Impute Missing Values
x <- c(1:4, NA, 6:7, NA)
x
x[is.na(x)] <-mean(x, na.rm = TRUE) 
round(x, 2) 

df<- data.frame(col1 = c(1:3, 99), col2 = c(2.5, 4.2, 99, 3.2))
df
df[df == 99] <-NA               # change 99s to NAs
df

df<-data.frame(col1 = c(1:3, NA), col2 = c("this", NA,"is", "text"),
               col3 = c(TRUE, FALSE, TRUE, TRUE), col4 = c(2.5, 4.2, 3.2, NA),
               stringsAsFactors = FALSE)
df$col4[is.na(df$col4)] <-mean(df$col4, na.rm= TRUE)       # mean value of col4.
df

# Exclude Missing Values
x <- c(1:4, NA, 6:7, NA)
mean(x)
mean(x, na.rm = TRUE)

complete.cases(df)
df[complete.cases(df),]
df[!complete.cases(df),]

na.omit(df)                            # omit all rows containing NAs.

#### Exercise ####
z <- airquality
z
is.na(z)
is.na(z$Temp)
is.na(z$Ozone)

which(is.na(z))
sum(is.na(z))

colSums(is.na(z))
complete.cases(z)
na.omit(z)

##################################################
########### Split and Apply Functions ###########
##################################################

#Sum/Mean by Categorical values
head(InsectSprays)

tapply(InsectSprays$count, InsectSprays$spray, sum)

# Split Data into Vectors Given a Variable
spIns = split(InsectSprays$count, InsectSprays$spray)
spIns

sprcount = lapply(spIns, sum)
sprcount

unlist(sprcount)

sapply(spIns, sum)

##################################################
### Combine two Data frames by Rows or Columns ###
##################################################

# cbind in r - data for example
activity <-data.frame(opid=c("Op01","Op02","Op03",
                             "Op04","Op05","Op06","Op07"),
                      units=c(23,43,21,32,13,12,32))
names <- data.frame(operator=c("Larry","Curly","Moe",
                               "Jack","Jill","Kim","Perry"))
blended <- cbind(activity, names)
blended

sourceofhire <- data.frame(found=c("Movie","Movie","Movie",
                                   "Book","Book","TV","TV"))
blended <- cbind(activity, names, sourceofhire)
blended


# rbind
rblended <- rbind(blended, blended)
rblended


# merge with common field
# Need some data to play with
df1 <- data.frame(LETTERS, dfindex = 1:26)
df2 <- data.frame(letters, dfindex = c(1:10,15,20,22:35))

# INNER JOIN: returns rows when there is a match in both tables.
merge(df1, df2)

# FULL (outer) JOIN: all records from both the tables and fill in NULLs for missing matches on either side.
merge(df1,df2, all=TRUE)

# what if column names don't match?
names(df1) <- c("alpha", "lotsaNumbers")

merge(df1, df2, by.x = "lotsaNumbers", by.y = "dfindex")


#############################################
################### Dplyr ###################
#############################################
library(dplyr)
library(datasets)
head(mtcars)

sub_m <- mtcars %>% 
  select(mpg, cyl, disp, hp, gear, carb) %>% 
  mutate(dispxhp = disp*hp)

names(sub_m)

table(mtcars$carb)

sub_m <- mtcars %>% 
  select(mpg, cyl, disp, hp, gear, carb) %>% 
  filter( carb %in% c(4,2,1))

table(sub_m$carb)

mtcars %>% 
  select(mpg, cyl, disp, hp, gear, carb) %>% 
  filter( carb %in% c(4,2,1)) %>%
  group_by(cyl) %>%
  summarise(hp_mean=mean(hp), disp_mean=mean(disp), n=n())




#############################################
################### Tidyr ###################
#############################################




#########################################################
################### Text Data Cleaning ##################
#########################################################
library(tm)

sentence=c('this is my 1st try example.','A person is nice', ' we can divide 10 with 2', 'Ahmed is a Gentle man')

txt <- Corpus(VectorSource(sentence))
txt_data<-tm_map(txt,stripWhitespace)
txt_data<-tm_map(txt_data,tolower)
txt_data<-tm_map(txt_data,removeNumbers)
txt_data<-tm_map(txt_data,removePunctuation)
txt_data <-tm_map(txt_data,removeWords, stopwords("english"))
#user define words to remove
txt_data <- tm_map(txt_data, removeWords,
                   c("and","the","our","that","for","are","also","more","has","must","have","should","this","with"))

df <- data.frame(cln_text=unlist(txt_data), stringsAsFactors=F)
df$cln_text



#################################################
################# Word Cloud ####################
#################################################
library(wordcloud)
wordcloud (txt_data)

#from Cameras dataset
d <- read.csv('./data/cameras.csv')
names(d)
wd <- d$street
wordcloud(wd, scale=c(5,0.5), random.order=FALSE, 
           rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(8, "Dark2"))


