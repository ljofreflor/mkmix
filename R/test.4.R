
# visualizacion

par(mfrow = c(2, 2))

d <- density(sample[, 35])
plot(d)

plot(sample[, 4], type = "l")
