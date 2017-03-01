library(dplyr)
library(GGally)
library(car)
library(caret)

data(mtcars)

mtcars <- mtcars %>%
  mutate(cyldisp = disp / cyl, pwr = hp / wt, gpm = 73 / mpg)  %>%
  select(gpm,cyl,cyldisp,hp,pwr,drat,wt,qsec,vs,am,gear,carb)

ggpairs(mtcars, lower = list(continuous = wrap("smooth", method = "lm")))

mtcars <- mtcars %>%
  transform(cyl = as.factor(cyl), vs = as.factor(vs), am = as.factor(am), gear = as.factor(gear), carb = as.factor(carb))
  #select(gpm,cyl,cyldisp,hp,pwr,drat,wt,qsec,vs,am,gear,carb)

findCorrelation(cor(mtcars), cutoff=.5)

fitAll <- glm(gpm ~ am + wt + cyldisp + cyl + hp + vs + drat + carb + gear + qsec + pwr , data=mtcars)
