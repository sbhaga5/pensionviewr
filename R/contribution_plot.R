#' Create a plot comparing ADEC contribution rates with actual contribution rates.
#'
#' @param data a dataframe produced by the selectedData function or in the same format containing columns for ADEC, and actual contributions to plot.
#' @param y1 The name of the ADEC variable
#' @param y2 The name of the actual contribution variable
#' @param labelY A label for the Y-axis
#' @param label1 A label for the ADEC variable
#' @param label2 A label for the actual contribution variable
#' @importFrom rlang .data
#' @export
contPlot <- function(data,
  .adec_var = "adec_contribution_rates",
  .actual_var = "actual_contribution_rates",
  labelY = NULL,
  label1 = "ADEC Contribution Rate",
  label2 = "Actual Contribution Rate") {

  reasonTheme <- get("reasonTheme")
  adec_var <- rlang::sym(.adec_var)
  actual_var <- rlang::sym(.actual_var)

  graph <- data %>%
    dplyr::select(
      .data$year,
      adec = !!adec_var,
      actual = !!actual_var
    ) %>%
    dplyr::mutate_all(dplyr::funs(as.numeric)) %>%
    tidyr::gather(key = "keys", value = "amount", -.data$year)

  lineColors <- c("adec" = "#FF6633",
    "actual" = "#333333")

  labs <- c("adec" = label1,
    "actual" = label2)

  ggplot2::ggplot(graph, ggplot2::aes(x = graph$year, y = graph$amount * 100)) +
    ggplot2::geom_line(ggplot2::aes(colour = graph$keys), size = 2) +
    ggplot2::scale_colour_manual(values = lineColors, labels = labs) +
    ggplot2::geom_hline(yintercept = 0, color = "black") +

    ggplot2::scale_y_continuous(
      breaks = scales::pretty_breaks(10),
      labels = function(b) {
        paste0(round(b, 0), "%")
      },
      expand = c(0, 0)
    ) +

    ggplot2::scale_x_continuous(breaks = scales::pretty_breaks(10),
        expand = c(0, 0)
      ) +

    ggplot2::ylab(labelY) +

    reasonTheme +
    ggplot2::theme(
      legend.justification = c(1, 1),
      legend.position = c(0.5, 1),
      legend.title = ggplot2::element_blank()
    )
}
