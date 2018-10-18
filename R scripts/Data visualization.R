library(tidyverse)
library(ggplot2)
library(dplyr)
attach(mpg)
View(mpg)

#Creating a ggplot 
#Plot mpg, putting displ on the x-axis and hwy in y-axis
ggplot() + geom_point(mapping = aes(x = displ, y = hwy, color = drv))
ggplot() + geom_point(mapping = aes(x = class, y = drv))
ggplot() + geom_point(mapping = aes(x = hwy, y = cyl))

##one way to add additional categorical information is to split your plot into "facets"
#"facet_wrap"
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl) + 
  facet_grid(~cyl)

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy)) 
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, color = drv),
              show.legend = FALSE)

#To display multiple geoms in the same plot, add multiple geom functions.
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))
#Alternatively

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()
  

#Using more aesthetics to beautify plots.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()

ggplot(data =  mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)

#Reproducing data analysis in ggplot 2
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()
#reproducing more data analysis result
ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))

## Diamond dataset in the diamond cut data

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))
# Displaying a bar chart of proportion instead of counts

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))

#Using the stat_summary that is use to summarize each value of y with a comparable value of x
ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth), 
    fun.ymax = max ,
    fun.ymin = min ,
    fun.y = mean
  )

#Position adjustment
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, color = cut))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))

ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
  geom_bar(alpha = 1/5, position = "identity")
ggplot(data = diamonds, mapping = aes(x = cut, colour = clarity)) + 
  geom_bar(fill = NA, position = "identity")


ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")













































































