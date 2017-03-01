suppressMessages(library(ggplot2))
suppressMessages(library(gridExtra))
suppressMessages(library(dplyr))

ex1 <- data.frame(val = rexp(1000, 1.33))
ex1Plot <-  ggplot(ex1, aes(x=val)) + 
  geom_density(col = "black", fill = "cornflowerblue", alpha = .25) +
  ggtitle(expression(paste("Exponential distribution with ", lambda, " = 1.33"))) +
  labs(x = "X", y = "Density") +
  theme_bw(base_size = 10)

ex2 <- data.frame(val = rexp(1000, .5))
ex2Plot <-  ggplot(ex2, aes(x=val)) + 
  geom_density(col = "black", fill = "cornflowerblue", alpha = .25) +
  ggtitle(expression(paste("Exponential distribution with ", lambda, " = 0.67"))) +
  labs(x = "X", y = "Density") +
  theme_bw(base_size = 10)

grid.arrange(ex1Plot, ex2Plot, nrow=1, ncol=2)


lambda <- .2
n <- 40
numSims <- 1000
mu <- 1 / lambda
simulations <- data.frame(t(replicate(numSims, rexp(n, lambda)))) %>%
  mutate(xBar = rowMeans(.), flux = sqrt(n) * (xBar - mu))
ggplot(simulations, aes(x=xBar)) +
  ggtitle("Histogram of Sample Means\n") +
  labs(x = "Means of 40 Random Exponentials", y = "Frequency") +
  geom_histogram(aes(y = ..density..), col = "azure4", fill = "cornflowerblue", 
                 alpha = .5, binwidth = .25) +
  geom_density(color = "chartreuse4", size = 1) +
  geom_vline(aes(xintercept = mean(xBar), color = "firebrick"), 
             show.legend = FALSE) +
  theme_bw(base_size = 10)


confInt <- t.test(simulations$xBar)$conf.int
sampleMean <- mean(simulations$xBar)
data.frame(Mean = c(sampleMean, mu), row.names = c("Sample", "Theoretical"))
lowerCI <- confInt[1]
upperCI <- confInt[2]


sigmaSq <- (1 / (lambda^2)) / n
sampleVariance <- var(simulations$xBar)
data.frame(Variance = c(sampleVariance, sigmaSq), 
           row.names = c("Sample", "Theoretical"))


ggplot(simulations, aes(x=flux)) +
  ggtitle("Histogram of Fluctuation\n") +
  labs(x = "Fluctuation of Mean of 40 Random Exponentials", y = "Frequency") +
  geom_histogram(aes(y = ..density..), col = "azure4", fill = "cornflowerblue",
                 alpha = .5, binwidth = 1) +
  geom_density(color = "chartreuse4", size = 1) +
  stat_function(fun = dnorm, color = "darkorange", size = 1, 
                args = list(mean = 0, sd = 5)) +
  geom_vline(aes(xintercept = mean(flux), color = "firebrick"), 
             show.legend = FALSE) +
  theme_bw(base_size = 10)


fluxMean <- mean(simulations$flux)
fluxSd <- sd(simulations$flux)
data.frame(Value = c(fluxMean, fluxSd), 
           row.names = c("Mean", "Standard Deviation"))


bigSim <- rexp(10000, .2)
par(mfrow=c(1,2))
qqnorm(y = simulations$xBar, col = "darkslateblue", 
       main = "Q-Q Plot of Sample Means")
qqline(y = simulations$xBar, col = "firebrick1")
qqnorm(y = bigSim, col = "darkslateblue", 
       main = "Q-Q Plot of Exp. Distribution")
qqline(y = bigSim, col = "firebrick1")


ex1 <- data.frame(val = rexp(1000, 1.33))
ex1Plot <-  ggplot(ex1, aes(x=val)) + 
  geom_density(col = "black", fill = "cornflowerblue", alpha = .25) +
  ggtitle(expression(paste("Exponential distribution with ", 
                           lambda, " = 1.33"))) +
  labs(x = "X", y = "Density") +
  theme_bw(base_size = 10)

ex2 <- data.frame(val = rexp(1000, .5))
ex2Plot <-  ggplot(ex2, aes(x=val)) + 
  geom_density(col = "black", fill = "cornflowerblue", alpha = .25) +
  ggtitle(expression(paste("Exponential distribution with ", 
                           lambda, " = 0.67"))) +
  labs(x = "X", y = "Density") +
  theme_bw(base_size = 10)

grid.arrange(ex1Plot, ex2Plot, nrow=1, ncol=2)
