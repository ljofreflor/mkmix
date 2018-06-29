#' Muestreo de Gibbs para el modelo mixto restringido
#' @description mcmc
#' @param n.iter number of iterations
#' @param data data object with observations
#' @importFrom invgamma rinvgamma
#' @export
constrained.mixed.model.mcmc <- function(n.iter, data){

  n.iter <- n.iter + 2000

  Y <- data$Y
  X <- data$X
  U <- data$U

  m <- ncol(U)/2
  n <- length(Y)

  # setear condiciones iniciales necesarias
  sigma2.g <- 1
  tau00_2.g <- 1
  tau11_2.g <- 1

  # partimos con prioris no informativas
  a.sigma2.g <- 0
  b.sigma2.g <- 0
  a.tau00_2.g <- 0
  b.tau00_2.g <- 0
  a.tau11_2.g <- 0
  b.tau11_2.g <- 0

  # cadenas
  chain.beta <- matrix(nrow = n.iter, ncol = ncol(X))
  chain.eta <- matrix(nrow = n.iter, ncol = ncol(U))
  chain.sigma2 <- matrix(nrow = n.iter, ncol = 1)
  chain.tau2 <- matrix(nrow = n.iter, ncol = 2)


  eta.g <- matrix(ncol = 1, nrow = ncol(U))
  eta.g[,] <- 0
  for (t in 1:n.iter) {

    # una muestra del vector de factores fijos
    sigma2.beta <- solve((1/sigma2.g) * t(X) %*% X)
    mu.beta <- sigma2.beta %*% (0 + (1/sigma2.g) * t(X) %*% (Y - U %*% eta.g))
    beta.g <- mvrnorm(mu = mu.beta, Sigma = sigma2.beta)

    chain.beta[t,] <- beta.g


    # actualizacion del vector de factores aleatorios
    for (i in 1:m) {

      s2.etai0 <- sigma2.g^(sum(U[, 2 * i - 1]^2) + sigma2.g/tau00_2.g)^(-1)
      s2.etai1 <- sigma2.g^(sum(U[, 2 * i]^2) + sigma2.g/tau11_2.g)^(-1)

      mu.etai0 <- (s2.etai0/sigma2.g) * (U[, 2 * i - 1] %*% (Y - X %*% beta.g))
      mu.etai1 <- (s2.etai1/sigma2.g) * (U[, 2 * i] %*% (Y - X %*% beta.g))

      eta.g[2 * i - 1, 1] <- rnorm(n = 1, mean = mu.etai0, sd = sqrt(s2.etai0))
      eta.g[2 * i, 1] <- rnorm(n = 1, mean = mu.etai1, sd = sqrt(s2.etai1))
    }

    chain.eta[t,] <- c(eta.g)

    # variabilidad global
    a.sigma2.g <- n/2
    b.sigma2.g <- (1/2) * t(Y - X %*% beta.g - U %*% eta.g) %*% (Y - X %*% beta.g - U %*% eta.g)
    sigma2.g = rinvgamma(1, shape = a.sigma2.g, rate = b.sigma2.g)

    chain.sigma2[t,] <- sigma2.g

    # variabilidad de intercepto aleatorio por factor
    a.tau00_2.g <- m/2
    b.tau00_2.g <- (1/2) * t(eta.g[seq(from = 1, to = m, by = 2)]) %*% (eta.g[seq(from = 1, to = m, by = 2)])
    tau00_2.g = rinvgamma(1, shape = a.tau00_2.g, rate = b.tau00_2.g)

    # variabilidad de la pendiente aleatoria por factor
    a.tau11_2.g <- m/2
    b.tau11_2.g <- (1/2) * t(eta.g[seq(from = 2, to = m, by = 2)]) %*% (eta.g[seq(from = 2, to = m, by = 2)])
    tau11_2.g = rinvgamma(1, shape = a.tau11_2.g, rate = b.tau11_2.g)

    chain.tau2[t,] <- c(tau00_2.g, tau11_2.g)
}

  # eliminar los primeros 2000 y saltar de 8 en 8
  index <- seq(from = 2000, to = n.iter, by = 8)
  list(chain.beta = chain.beta, chain.tau2 = chain.tau2, chain.sigma2 = chain.sigma2, chain.eta = chain.eta)
}
