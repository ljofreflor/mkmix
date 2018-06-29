library(mkmix)

data <- data.generation(n.fixed.effects = 5, n.random.effects = 5, n.sample = 10000)
mcmc.sample <- constrained.mixed.model.mcmc(n.iter = 100000, data = data)


d <- density(mcmc.sample$chain.beta[, 1])
plot(d)

d <- density(sort(mcmc.sample$chain.sigma2[, 1])[1:30000])
plot(d)

# ==== cadena ==== #
plot(mcmc.sample[,2], type = 'l')

