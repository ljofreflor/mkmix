#' @importFrom stats density
#' @export
get.mkmix.object <- function(data.frame.in, fixed.effects, random.effect, log.p, log.q){
  # leer las covariables de interes
  rubro.marca.eta <- data.frame.in[,c(random.effect)]
  y <- data.frame.in[, c(log.q)]
  l <- data.frame.in[,c(log.p)]
  n <-length(l)
  z <- as.matrix(data.frame.in[, fixed.effects])

  # construimos la matriz X a partir de las covariables y el logaritmo del precio
  d <- diag(length(l))
  diag(d) <- l


  X <- cbind(matrix(rep(1, n), ncol = 1), d%*%z)

  # construimos la matriz U a partir de las dummy y el precio
  dummy <- as.matrix(dummy_columns(rubro.marca.eta)[, -1])
  U <- combine_matrix(dummy, d %*% dummy)
  list(Y=y,X=X, U=U)
}
