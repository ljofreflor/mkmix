#' Funciones genericas
#'
#' @description Combine Matrix asdf
#'
#' @param matrix.odd matrix.odd
#' @param matrix.even matrix.even
#' @export
combine_matrix <- function(matrix.odd, matrix.even) {
    rows.combined <- nrow(matrix.odd)
    cols.combined <- ncol(matrix.odd) + ncol(matrix.even)
    matrix.combined <- matrix(NA, nrow = rows.combined, ncol = cols.combined)
    matrix.combined[, seq(1, cols.combined, 2)] <- matrix.odd
    matrix.combined[, seq(2, cols.combined, 2)] <- matrix.even
    matrix.combined
}
