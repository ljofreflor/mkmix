# gibbs

Y <- data$Y
X <- data$X
U <- data$U

# seteamos condiciones iniciales para todos los parametros
n_iter <- 10000
m <- ncol(U)/2
n <- length(Y)
data_sim <- matrix(ncol = 10, nrow = n_iter)
beta.g <- data$beta
eta.g <- data$eta
sigma2.g <- data$sigma2
tau00_2.g <- data$tau00_2
tau11_2.g <- data$tau11_2

# partimos con prioris no informativas
a.sigma2.g <- 0
b.sigma2.g <- 0
a.tau00_2.g <- 0
b.tau00_2.g <- 0
a.tau11_2.g <- 0
b.tau11_2.g <- 0

chain <- matrix(nrow = n_iter, ncol = 1000)


for (t in 1:n_iter) {
    
    # una muestra del vector de factores fijos
    sigma2.beta <- solve((1/sigma2.g) * t(X) %*% X)
    
    mu.beta <- sigma2.beta %*% (0 + (1/sigma2.g) * t(X) %*% (Y - U %*% eta.g))
    beta.g <- mvrnorm(mu = mu.beta, Sigma = sigma2.beta)
    
    chain[t, 1:length(beta.g)] <- beta.g
    
    # actualizacion del vector de factores aleatorios
    for (i in 1:m) {
        
        s2.etai0 <- sigma2.g^(sum(U[, 2 * i - 1]^2) + sigma2.g/tau00_2.g)^(-1)
        s2.etai1 <- sigma2.g^(sum(U[, 2 * i]^2) + sigma2.g/tau11_2.g)^(-1)
        
        mu.etai0 <- (s2.etai0/sigma2.g) * (U[, 2 * i - 1] %*% (Y - X %*% beta.g))
        mu.etai1 <- (s2.etai1/sigma2.g) * (U[, 2 * i] %*% (Y - X %*% beta.g))
        
        eta.g[2 * i - 1, 1] <- rnorm(n = 1, mean = mu.etai0, sd = sqrt(s2.etai0))
        eta.g[2 * i, 1] <- rnorm(n = 1, mean = mu.etai1, sd = sqrt(s2.etai1))
    }
    
    chain[t, (length(beta.g) + 1):(length(beta.g) + length(eta.g))] <- c(eta.g)
    
    # variabilidad global
    a.sigma2.g <- n/2
    b.sigma2.g <- (1/2) * t(Y - X %*% beta.g - U %*% eta.g) %*% (Y - X %*% beta.g - U %*% eta.g)
    sigma2.g = rinvgamma(1, shape = a.sigma2.g, rate = b.sigma2.g)
    
    chain[t, (length(beta.g) + length(eta.g) + 1):(length(beta.g) + length(eta.g) + 2)] <- sigma2.g
    
    # variabilidad de intercepto aleatorio por factor
    a.tau00_2.g <- m/2
    b.tau00_2.g <- (1/2) * t(eta.g[seq(from = 1, to = m, by = 2)]) %*% (eta.g[seq(from = 1, to = m, by = 2)])
    tau00_2.g = rinvgamma(1, shape = a.tau00_2.g, rate = b.tau00_2.g)
    
    # variabilidad de la pendiente aleatoria por factor
    a.tau11_2.g <- m/2
    b.tau11_2.g <- (1/2) * t(eta.g[seq(from = 2, to = m, by = 2)]) %*% (eta.g[seq(from = 2, to = m, by = 2)])
    tau11_2.g = rinvgamma(1, shape = a.tau11_2.g, rate = b.tau11_2.g)
}

# eliminar los primeros 2000 y saltar de 8 en 8
index <- seq(from = 2000, to = n_iter, by = 8)

sample <- chain[index, ]
