mu1 <- 0
mu2 <- 5
sd1 <- 1.3
sd2 <- 2
pi <- 0.45

dnormmix <- function(x) {
  pi * dnorm(x, mu1, sd1) + (1 - pi) * dnorm(x, mu2, sd2)
}

xmin <- -3
xmax <- 10

pdf("~/Documents/teaching/2019/spring/stat343/stat343_s2019/materials/20190301_mcmc/post.pdf", width = 7, height = 4)
ggplot(data = data.frame(x = c(xmin, xmax)), mapping = aes(x = x)) +
  stat_function(fun = dnormmix) +
  xlab(expression(theta)) +
  ylab(expression(paste(f, "(", theta, " | ", x[1], ..., x[n], ")"))) +
  theme_bw(base_size = 16)
dev.off()
