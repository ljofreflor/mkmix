library(mkmix)
library(xtable)

estimate.mode <- function(x) {
  temp <- density(x)
  temp$x[which.max(temp$y)]
}

data("consumo")

sales.data <- mkmix::get.mkmix.object(data.frame.in = consumo,
                                      fixed.effects = c("PRENSA",
                                                        "TV",
                                                        "CATALOGO"),
                                      random.effect = "RUBRO_MARCA",
                                      log.p = "lP",
                                      log.q = "lQ")

mcmc.sample <- mkmix::constrained.mixed.model.mcmc(n.iter = 10000,
                                                   data = sales.data)

ee <- matrix(nrow = ncol(mcmc.sample$chain.eta))
for(i in 1:ncol(mcmc.sample$chain.eta)) {
  ee[i,1] <-estimate.mode(mcmc.sample$chain.eta[,i])
}

bb <- matrix(nrow = ncol(mcmc.sample$chain.beta))
for(i in 1:ncol(mcmc.sample$chain.beta)) {
  bb[i,1] <-estimate.mode(mcmc.sample$chain.beta[,i])
}
