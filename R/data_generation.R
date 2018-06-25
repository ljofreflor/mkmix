data_generation <- function(p, m, n) {
    "
  generacion de datos artificiales con los que probaremos la estimacion del modelo
  jerarquico
  "
    sigma2 <- 25
    tau00_2 <- 20
    tau11_2 <- 10
    # simulacion construccion de la data de entrada
    group <- sort(sample(1:m, n, replace = T))
    # agregar intercepto
    dummy <- as.matrix(fastDummies::dummy_columns(group)[, -1])
    # variable longitudinal
    l <- matrix(rnorm(n = n, mean = 0, sd = 1), nrow = n, ncol = 1)
    d <- diag(n)
    diag(d) <- l
    U <- combine_matrix(dummy, d %*% dummy)
    # punto de validacion de la matriz
    stopifnot(sum(sum(U)) == n + sum(l))
    # covariables aleatorias para testear
    A <- matrix(rnorm(n = n * p, mean = 10, sd = 5), n, p)
    A <- d %*% A
    # agregar intercepto
    X <- cbind(ones(n, 1), A)
    # matriz Q que representa la covarianza entre el factor aleatorio del intercepto con la pendiente, en
    # este caso, independientes.
    Q <- matrix(nrow = 2, ncol = 2)
    Q[1, 1] <- tau00_2
    Q[2, 2] <- tau11_2
    Q[2, 1] <- 0
    Q[1, 2] <- 0
    # matriz de varianza covarianza de los factores aleatorios
    G <- do.call(adiag, rep(list(Q), ncol(U)/2))
    # generar los factores aleatorios
    eta <- matrix(mvrnorm(mu = rep(0, ncol(U)), Sigma = G), nrow = ncol(U), ncol = 1)
    # generar los factores fijos, para testear generamos solo unos
    beta <- matrix(rep(1, p + 1), nrow = p + 1, ncol = 1)
    # error
    eps <- matrix(rnorm(n = n, mean = 0, sd = sqrt(sigma2)), ncol = 1)
    # generar una variable de respuesta a partir de los datos
    Y <- X %*% beta + U %*% eta + eps
    list(X = X, U = U, Y = Y, beta = beta, eta = eta, tau00_2 = tau00_2, tau11_2 = tau11_2, sigma2 = sigma2, 
        group = group)
}
