
data <- data_generation(p = 3, m = 5, n = 10000)

# podemos testear la generaci<c3><b3>n de datos mediante la libreria


y <- data$Y
X <- data$X
group <- factor(data$group)

lmer(y ~ (1 | group) + (X[, 2] | group) + (X[, 3] | group))


