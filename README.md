
<!-- README.md is generated from README.Rmd. Please edit that file -->
mkmix
=====

El objetivo de mkmix es un modelo mixto bayesiano, aplicable al caso muy particular de estimación de elasticidad en retail.

Instalación
-----------

Puede instalar la versión de desarrollo [GitHub](https://github.com/) con:

``` r
# install.packages("devtools")
devtools::install_github("ljofre/mkmix")
```

Example
-------

este es un pequeño ejemplo de como usar la librería para nuestro set de prueba

``` r
library(mkmix)
library(knitr)

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

mcmc.sample <- mkmix::constrained.mixed.model.mcmc(n.iter = 10,
                                                   data = sales.data)
```

las estimaciones se obtienen obteniendo la moda de la distribución posterior.

``` r
ee <- matrix(nrow = ncol(mcmc.sample$chain.eta))
for(i in 1:ncol(mcmc.sample$chain.eta)) {
  ee[i,1] <-estimate.mode(mcmc.sample$chain.eta[,i])
}
```

``` r
bb <- matrix(nrow = ncol(mcmc.sample$chain.beta))
for(i in 1:ncol(mcmc.sample$chain.beta)) {
  bb[i,1] <-estimate.mode(mcmc.sample$chain.beta[,i])
}
```

las cuales generan los siguientes resultados

``` r
kable(ee, caption = "estimacion de efectos aleatorios de subrubro marca")
#> Warning in kable_markdown(x, padding = padding, ...): The table should have
#> a header (column names)
```

|            |
|-----------:|
|  -0.3469686|
|   1.9210583|
|  -0.2673754|
|  -1.4240599|
|   0.0908148|
|  -0.0861273|
|   0.0728697|
|   0.4736784|
|  -0.0998648|
|   0.8536681|
|   0.1697412|
|  -1.9413609|
|  -0.0371081|
|  -1.6609936|
|  -0.2110680|
|  -2.0033764|
|   0.0015011|
|  -1.2895406|
|  -0.3187153|
|  -2.6435745|
|   0.0801550|
|  -0.3206001|
|  -0.0837154|
|   0.8340181|
|  -0.1441130|
|  -0.0336704|
|  -0.3554069|
|  -1.6480985|
|   0.1829560|
|   0.3644055|
|  -0.1101950|
|   1.2417677|
|  -0.1349716|
|  -1.3017680|
|  -0.3926427|
|  -0.5906520|
|  -0.2861070|
|  -1.7294208|
|   0.1336710|
|   1.1665507|
|   0.0074000|
|   0.8231475|
|  -0.2652535|
|  -0.7660657|
|   0.1857607|
|   0.9592710|
|  -0.1155177|
|   0.2132683|

y también

``` r

kable(bb, caption = "estimacion de efectos fijos de canales de promoción: intercepto, prensa, tv, catálogo ")
#> Warning in kable_markdown(x, padding = padding, ...): The table should have
#> a header (column names)
```

|            |
|-----------:|
|  -0.0728316|
|   0.2654721|
|  -0.9797143|
|  -0.0178835|

se pueden visualizar las cadenas y distribuciones posteriores

``` r
# canera para el segundo efecto fijo (el primero es el intercepto)
plot(mcmc.sample$chain.beta[,2], type='l')
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

``` r
# densidad empirita del 4 efecto aleatorio de la pendiente 
den.eta.4.slope <- density(mcmc.sample$chain.eta[,8])
plot(den.eta.4.slope)
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />
