#' Create a plot comparing ADEC contribution rates with actual contribution rates.
#'
#' @param data a dataframe produced by the selectedData function or in the same format containing columns for ADEC, actual and optionally a third column to plot.
#' @param y1 The name of the ADEC variable
#' @param y2 The name of the actual contribution variable
#' @param y3 The name of an optional third variable
#' @param labelY A label for the Y-axis
#' @param label1 A label for the ADEC variable
#' @param label2 A label for the actual contribution variable
#' @param label3 A label for the third variable
#' @importFrom rlang .data
#' @export
contPlot <- function(data,
  y1 = "ADEC Contribution Rates",
  y2 = "Actual Contribution Rates (Statutory)",
  y3 = NULL,
  labelY = NULL,
  label1 = NULL,
  label2 = NULL,
  label3 = NULL) {
  reasonTheme <- get("reasonTheme")
  graph <- data %>%
    dplyr::select(
      .data$year,
      label1 = .data$y1,
      label2 = .data$y2,
      label3 = .data$y3
    ) %>%
    dplyr::mutate_all(dplyr::funs(as.numeric)) %>%
    tidyr::gather(key = .data$keys, value = .data$amount,-.data$year)

  lineColors <- c(y1 = "#FF6633",
    y2 = "#3300FF",
    y3 = "#333333")

  labs <- c(label1,
    label2,
    label3)

  ggplot2::ggplot(graph, ggplot2::aes(x = graph$year)) +
    ggplot2::geom_line(ggplot2::aes(y = graph$amount * 100, color = graph$keys), size = 2) +
    ggplot2::scale_fill_manual(values = lineColors) +
    ggplot2::geom_hline(yintercept = 0, color = "black") +

    ggplot2::scale_y_continuous(
      breaks = scales::pretty_breaks(10),
      labels = function(b) {
        paste0(round(b, 0), "%")
      }
    ) +

    ggplot2::scale_x_continuous(breaks = scales::pretty_breaks(10)) +

    ggplot2::ylab(labelY) +
    ggplot2::scale_color_discrete(labels = labs) +

    reasonTheme +
    ggplot2::theme(
      legend.justification = c(1, 1),
      legend.position = c(0.5, 1),
      legend.title = ggplot2::element_blank()
    )
}
