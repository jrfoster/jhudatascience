library(ggplot2)
data(mtcars)
x <- mtcars$wt
y <- mtcars$mpg
z <- mtcars$cyl
w <- mtcars$disp
g <- ggplot(data.frame(x = x, y = resid(lm(y ~ x + z + w))), aes(x = x, y = y)) +
  geom_hline(yintercept = 0, size = 2) +
  geom_point(size = 7, colour = "black", alpha = 0.4) +
  geom_point(size = 5, colour = "red", alpha = 0.4) +
  xlab("X") +
  ylab("Residual")
g

data(mtcars)
fit <- lm(mpg ~ factor(am), data=mtcars)
wr <- resid(fit)
qqnorm(wr, main = "am")
qqline(wr)

summary(fit)

ggplot(data.frame(x = factor(mtcars$am), y = wr), aes(x = factor(mtcars$am), y = mtcars$mpg)) +
  geom_hline(yintercept = 0, size = 2) +
  geom_point(size = 7, colour = "black", alpha = 0.4) +
  geom_point(size = 5, colour = "red", alpha = 0.4) +
  xlab("X") +
  ylab("Residual")







wr <- resid(lm(mpg ~ cyl, data=mtcars))
qqnorm(wr, main = "cyl")
qqline(wr)

wr <- resid(lm(mpg ~ disp, data=mtcars))
qqnorm(wr, main = "disp")
qqline(wr)

wr <- resid(lm(mpg ~ hp, data=mtcars))
qqnorm(wr, main = "hp")
qqline(wr)

wr <- resid(lm(mpg ~ drat, data=mtcars))
qqnorm(wr, main = "drat")
qqline(wr)

wr <- resid(lm(mpg ~ wt, data=mtcars))
qqnorm(wr, main = "wt")
qqline(wr)

wr <- resid(lm(mpg ~ vs, data=mtcars))
qqnorm(wr, main = "vs")
qqline(wr)

wr <- resid(lm(mpg ~ am, data=mtcars))
qqnorm(wr, main = "am")
qqline(wr)

wr <- resid(lm(mpg ~ gear, data=mtcars))
qqnorm(wr, main = "gear")
qqline(wr)

wr <- resid(lm(mpg ~ carb, data=mtcars))
qqnorm(wr, main = "carb")
qqline(wr)