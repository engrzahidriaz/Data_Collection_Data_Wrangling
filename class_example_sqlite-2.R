
# Load the RSQLite Library
library(RSQLite)
# Load the mtcars as an R data frame put the row names as a column, and print the header.

data("mtcars")
mtcars$car_names <- rownames(mtcars)
rownames(mtcars) <- c()
head(mtcars)
# Create a connection to our new database, CarsDB.db
# you can check that the .db file has been created on your working directory
getwd()
setwd('./data')
getwd()

#############################################################
############# Creating Databases and Tables #################
#############################################################

# Create or connect to database
conn <- dbConnect(RSQLite::SQLite(), "CarsDB.db") # correct path to DB

# Write the mtcars dataset into a table names mtcars_data
dbWriteTable(conn, "cars_data", mtcars)

# List all the tables available in the database
dbListTables(conn)

# Quick access functions
dbListFields(conn, "cars_data")

# read mtcar in database with name cars_data
rdd <- dbReadTable(conn, "cars_data")


############### Exercise #############
#TODO: Insert following data into DB Tables
# datasets::AirPassengers
# datasets::Loblolly

conect <- dbConnect(RSQLite::SQLite(), 'passengersDB.db')
dbWriteTable(conect, 'passengers_data', airquality)
dbListTables(conect)
dbListFields(conect, "passengers_data")
red <- dbReadTable(conect, "passengers_data")

AirPassengers

data("AirPassengers")
AirPassengers$passengers_names <- rownames(AirPassengers)
rownames(AirPassengers) <- c()
head(AirPassengers)

dbWriteTable(conect, 'passengers_data', AirPassengers)
dbListTables(conect)
dbListFields(conect, "passengers_data")
red <- dbReadTable(conect, "passengers_data")

#############################################################
################ Executing SQL Queries ######################
#############################################################

dbGetQuery(conn,"SELECT * FROM cars_data LIMIT 5 ")


# Get the car names and horsepower starting with M that have 6 or 8 cylinders
dbGetQuery(conn,"SELECT car_names, hp, cyl FROM cars_data
                 WHERE car_names LIKE 'M%' AND cyl IN (6,8)")


# Get the average horsepower and mpg by number of cylinder groups
dbGetQuery(conn,"SELECT cyl, AVG(hp) AS 'average_hp', AVG(mpg) AS 'average_mpg' FROM cars_data
                 GROUP BY cyl
                 ORDER BY average_hp")


avg_HpCyl <- dbGetQuery(conn,"SELECT cyl, AVG(hp) AS 'average_hp'FROM cars_data
                 GROUP BY cyl
                 ORDER BY average_hp")
avg_HpCyl
class(avg_HpCyl)

#############################################################
### Insert Variables into Queries (Parameterised Queries) ###
#############################################################

### User is looking for cars that have over 18 miles per gallon (mpg)
# and more than 6 cylinders
mpg <-  18
cyl <- 4
Result <- dbGetQuery(conn, 'SELECT car_names, mpg, cyl FROM cars_data WHERE mpg >= ? AND cyl >= ?', 
                     params = c(mpg,cyl))
Result

#####################################################
### Statements That Do Not Return Tabular Results ###
#####################################################

# Visualize the table before deletion
dbGetQuery(conn, "SELECT * FROM cars_data LIMIT 10")

# Delete the column belonging to the Mazda RX4. You will see a 1 as the output.
dbExecute(conn, "DELETE FROM cars_data WHERE car_names = 'Mazda RX4'")

# Visualize the new table after deletion
dbGetQuery(conn, "SELECT * FROM cars_data LIMIT 10")

# Insert the data for the Mazda RX4. This will also ouput a 1
dbExecute(conn, "INSERT INTO cars_data VALUES (21.0,6,160.0,110,3.90,2.620,16.46,0,1,4,4,'Mazda RX4')")

# See that we re-introduced the Mazda RX4 succesfully at the end
dbGetQuery(conn, "SELECT * FROM cars_data")

#####################################################
###### https://db.rstudio.com/databases/sqlite/ #####
#####################################################

# You can fetch all results:
res <- dbSendQuery(conn, "SELECT * FROM cars_data WHERE cyl = 6")
dbFetch(res)

# Clear the result
dbClearResult(res)

# Or a chunk at a time
res <- dbSendQuery(conn, "SELECT * FROM cars_data WHERE cyl = 8")
while(!dbHasCompleted(res)){
  chunk <- dbFetch(res, n = 5)
  print(nrow(chunk))
}

# Clear the result
dbClearResult(res)


# Disconnect from the database
dbDisconnect(conn)

