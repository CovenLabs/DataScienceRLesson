library(tidyverse)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) 
filter(mpg, cyl = 8)
filter(diamonds, carat > 3)

library(nycflights13)
library(tidyverse)

#To explore the basic data manipulation verbs in dplyr, we'll
?flights
flights

#To see the data in a sheet
View(flights)
####Dplyr
#Pick observation by their values (filter())
#Reorder the rows (arrange())
#Pick variables by their names (select())
#Create new variable with functions of existing variables(mutate()).
#Collapse many values down to single summary (summarise())


######Filter allows you to select observation based on their values.
filter(flights, month == 1, day == 1)
#Assigns the variable to the filtered dataset
jan1 <- filter(flights, month == 1, day == 1)
Dec25 <- filter(flights, month == 12, day == 25)
#A short logical operation is x %in% y
nov_dec <- filter(flights, month %in% c(11,12))
#Sometimes using De morgan's law: !(x&y) same as !x|!y, and !(x|y) is the same as
#!x&!y. For example, if you wanted to find flights that weren't delay(on arrival or departure),
#by more than two hours, you could use either of the following filters

filter(flights, !(arr_delay > 120| dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)

##Missing values
#One of the most important features of R that you can be comparison tricky is missing values
#let take a logic looks at this.

#Let x be Mary's age. We don't know how old she is.
x <- NA
#Let y be John's age. We don't know how old he is.
y <- NA
#Are John and Mary the same age?
x == y
#We don't know!

#If you want to determine if a value is missing, use "is.na"
is.na(x)

#filter() only includes rows where the condition is TRUE; it excludes bothj false 
#and NA values. If you want to preserve missing values, ask for them explicitly.
df <- tibble(x = c(1, NA, 3))
filter(df, x > 1)
filter(df, is.na(x) | x > 1)

##Arrange() works similarly to filter(), except that instead of selecting rows,
#it changes their order.
arrange(flights, year, month, day)
#Use desc to re-arrange a row in descending order.
arrange(flights, desc(arr_delay))
##Missing values are usually sorted at the end
df <- tibble(x = c(5,2, NA))
arrange(df, x)
#Arrangement in descending order
arrange(df, desc(x))




#### Add new variable with mutate
flights.sml <- select(flights, 
    year:day , 
    ends_with("delay"),
    distance,
    air_time
    )
mutate(flights.sml, 
       gain = arr_delay - dep_delay,
       speed = distance / air_time * 60
       )

## Note you can refer to the column you have created.
mutate(flights.sml, 
       gain = arr_delay - dep_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
       )
## If you want to keep the new variables, use transmute.
transmute(flights, 
          gain = arr_delay - dep_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
          )
#Modular arithmetic:%/%
transmute(flights,
          dep_time ,
          hour = dep_time %/% 100 ,
          minute = dep_time %/% 100 )
##Offsets: lead() and lag() allow you to refer to leading or lagging values.
(x <- 1:10)
lag(x)
lead(x)



#Summarise, collapse a data frame to single row
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))
#Summarise is not terribly useful we pair it with group_by().
by.day <- group_by(flights, year, month, day)
summarise(by.day, delay = mean(dep_delay, na.rm = TRUE))


#Combining multiple operations with pipe
#Imagining that we want to explore the relationship between the distance and the 
#average delay for each location. 
by_dest <- group_by(flights, dest)
delay <- summarise(by_dest , 
                   count = n(),
                   dist = mean(distance, na.rm = TRUE) ,
                   delay = mean(arr_delay, na.rm = TRUE)
                   )
delay <- filter(delay, count > 20, dest != "HNL")

# It looks like delays increase with distance up to ~750 miles 
# and then decrease. Maybe as flights get longer there's more 
# ability to make up delays in the air?
ggplot(data = delay, mapping = aes(x = dist, y = delay)) + 
  geom_point(aes(size = count), alpha = 1/3) + 
  geom_smooth(se = FALSE)
# There are three steps to prepare this datasets
## 1. Group flights by destination
## 2. Summarise to compute distance, average delay, and number of flights.
## 3. Filter to remove noisy points and Honolulu airport, which is almost twice as far as the next airport.
delays <- flights %>%
  group_by(dest) %>%
  summarise(
    count = n(), 
    dist  = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>%
  filter(count > 20, dest != "HNL")

### Working on na.rm()
flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay, na.rm = TRUE))

##In this case, where missing values represent cancelled flights,
#we could also tackle the problem by first removing the cancelled flights.
#We'll save this dataset so we can reuse in the next few examples.
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

#Whenever you do any aggregation, it's always a good idea to include either a count (n())
#or a count of non-missing values (sum(!is.na(x))). 
# That way you can check that you're not drawing conclusions based on very small amounts of data.

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)
##Wow, there are some planes that have an average delay of 5 hours (300 minutes)!
#The story is actually a little more nuanced. We can get more insight if we draw a
#scatterplot of number of flights vs. average delay:
delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

ggplot(data = obama_data) + 
  geom_bar(mapping = aes(x = Comment, y = likes_count))

ggplot(dtaa = obama_data) + 
  geom_point(mapping = aes(x = ))











































































































