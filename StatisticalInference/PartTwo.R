suppressMessages(library(datasets))
suppressMessages(library(ggplot2))
suppressMessages(library(dplyr))
suppressMessages(library(knitr))
suppressMessages(library(GGally))
data("ToothGrowth")


str(ToothGrowth)
paste("Complete Cases:", sum(complete.cases(ToothGrowth)))


ToothGrowth %>%
  ggplot(aes(x=factor(dose), y=len, group=supp, color=supp)) +
  ggtitle("Odontoblast Length as a Function of Dose\n") +
  labs(x = "Dosage (mg)", y = "Odontoblasts Length (microns)", color="Supplement") +
  geom_point() +
  stat_summary(aes(group=supp, color=supp), fun.y=mean, geom="line") +
  theme_bw(base_size = 10)

stat1 <- ToothGrowth %>%
  group_by(dose, supp) %>%
  summarize(range=paste(min(len), "-", max(len)), first = quantile(len, probs=.25), third = quantile(len, probs=.75), mean = mean(len), median=median(len), var=var(len))
kable(x=stat1, digits=2, col.names=c("Dose", "Supplement", "Range", "1st Quartile", "3rd Quartile", "Median", "Mean", "Variance"))

sVC <- ToothGrowth %>% filter(supp == 'VC')
sOJ <- ToothGrowth %>% filter(supp == 'OJ')
d05 <- ToothGrowth %>% filter(dose == .5)
d1 <- ToothGrowth %>% filter(dose == 1)
d2 <- ToothGrowth %>% filter(dose==2)
kable(data.frame(var(sVC$len), var(sOJ$len), var(d05$len), var(d1$len), var(d2$len)), col.names = c("Orange Juice","Ascorbic Acid",".05mg","1mg","2mg"))


t1 <- t.test(sOJ$len, sVC$len, paired=FALSE, var.equal=FALSE)
kable(data.frame("Ascorbic Acid", "Orange Juice", paste("[", round(t1$conf.int[1],4), ", ", round(t1$conf.int[2],4), "]", sep=""), round(unname(t1$parameter), 2),  qt(.975, unname(t1$parameter)), unname(t1$statistic), t1$p.value), col.names = c("Group 1 Supp", "Group 2 Supp", "Conf Int", "Deg F", "Tabulated t-value", "t-Statistic", "p-value"))

t2 <- t.test(d1$len, d05$len, paired=FALSE, var.equal=FALSE)
t3 <- t.test(d2$len, d05$len, paired=FALSE, var.equal=FALSE)
t4 <- t.test(d2$len, d1$len,  paired=FALSE, var.equal=FALSE)
g1dose <- c("1", "2", "2")
g2dose <- c(".5", ".5", "1")
ci <- c(paste("[", round(t2$conf.int[1], 4), ", ", round(t2$conf.int[2], 4), "]", sep=""), 
        paste("[", round(t3$conf.int[1], 4), ", ", round(t3$conf.int[2], 4), "]", sep=""), 
        paste("[", round(t4$conf.int[1], 4), ", ", round(t4$conf.int[2], 4), "]", sep=""))
df <- c(unname(t2$parameter),
        unname(t3$parameter),
        unname(t4$parameter))
tT <- c(qt(.975, unname(t2$parameter)),
        qt(.975, unname(t3$parameter)),
        qt(.975, unname(t4$parameter)))
cT <- c(unname(t2$statistic),
        unname(t3$statistic),
        unname(t4$statistic))
pval <- c(t2$p.value, t3$p.value, t4$p.value)
kable(data.frame(g1dose, g2dose, ci, df, tT, cT, pval), col.names = c("Group 1 Dose","Group 2 Dose","Conf Int", "Deg F", "Tabulated t-value", "t-Statistic", "p-value"))

allP <- c(t1$p.value, t2$p.value, t3$p.value, t4$p.value)
g1 <- c("Ascorbic Acid", "1", "2", "2")
g2 <- c("Orange Juice", ".5", ".5", "1")
adjP <- p.adjust(allP, method="bonferroni")
origConclusion <- allP > .05
adjConclusion <- adjP > .05
kable(data.frame(g1, g2, allP, origConclusion, adjP, adjConclusion), col.names = c("Group1", "Group 2", "Original p-value", "> alpha?", "Adjusted p-value", "> alpha?"))adjConclusion <- adjP > .025
adjP <- p.adjust(allP, method="BH")
adjConclusion <- adjP > .05
kable(data.frame(g1, g2, allP, origConclusion, adjP, adjConclusion), col.names = c("Group1", "Group 2", "Original p-value", "> alpha?", "Adjusted p-value", "> alpha?"))

ToothGrowth$dose <- as.factor(ToothGrowth$dose)
ggpairs(ToothGrowth)

lsVC <- length(sVC$len); sdsVC <- sd(sVC$len); lsOJ <- length(sOJ$len) 
sdsOJ <- sd(sOJ$len); t1dl <- mean(sVC$len) - mean(sOJ$len)
t1sp <- sqrt((((lsOJ-1) * sdsOJ^2) + ((lsVC-1) * sdsVC^2)) / (lsOJ + lsVC - 2))
t1p <- power.t.test(n=30,sd=t1sp,delta=t1dl,sig.level=.95,type="two.sample",
                    alternative="two.sided")$power
ld1 <- length(d1$len); sdd1 <- sd(d1$len); ld05 <- length(d05$len)
sdd05 <- sd(d05$len); t2dl <- mean(d1$len) - mean(d05$len)
t2sp <- sqrt((((ld05-1) * sdd05^2) + ((ld1-1) * sdd1^2)) / (ld05 + ld1 - 2))
t2p <- power.t.test(n=30,sd=t2sp,delta=t2dl,sig.level=.95,type="two.sample",
                    alternative="two.sided")$power
ld2 <- length(d2$len); sdd2 <- sd(d2$len); ld05 <- length(d05$len)
sdd05 <- sd(d05$len); t3dl <- mean(d2$len) - mean(d05$len)
t3sp <- sqrt((((ld05-1) * sdd05^2) + ((ld2-1) * sdd2^2)) / (ld05 + ld2 - 2))
t3p <- power.t.test(n=30,sd=t3sp,delta=t3dl,sig.level=.95,type="two.sample",
                    alternative="two.sided")$power
ld1 <- length(d1$len); sdd1 <- sd(d1$len); ld2 <- length(d2$len)
sdd2 <- sd(d2$len); t4dl <- mean(d1$len) - mean(d2$len)
t4sp <- sqrt((((ld2-1) * sdd2^2) + ((ld1-1) * sdd1^2)) / (ld2 + ld1 - 2))
t4p <- power.t.test(n=30,sd=t4sp,delta=t4dl,sig.level=.95,type="two.sample",
                    alternative="two.sided")$power
kable(data.frame(round(t1p,4),round(t2p,4),round(t3p,4),round(t4p,4)),
      col.names=c("OJ-VC Power",".5mg-1mg Power",
                  ".5mg-2mg Power","1mg-2mg Power"))