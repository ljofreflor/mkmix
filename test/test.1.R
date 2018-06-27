library(mkmix)


data <- data.generation(n.fixed.effects = 2, n.random.effects = 2, n.sample = 500)
mcmc.sample <- constrained.mixed.model.mcmc(n.iter = 100000,  data = data)
d <- density(mcmc.sample[, 9])
plot(d)

# ==== cadena ==== #
plot(mcmc.sample[,2], type = 'l')

