#' Create a plot comparing two variables, such as ADEC vs. Actual contributions.
#'
#' @param data a dataframe produced by the selectedData function or in the same format.
#' @param .var1 The name of the first variable to plat, default is adec_contribution_rates.
#' @param .var2 The name of the second variable to plot, default if actual_contribution_rates.
#' @param labelY A label for the Y-axis.
#' @param label1 A label for the first variable.
#' @param label2 A label for the second variable.
#' @importFrom rlang .data
#' @export

linePlot <- function(data,
  .var1 = "adec_contribution_rates",
  .var2 = "actual_contribution_rates",
  labelY = NULL,
  label1 = "ADEC Contribution Rate",
  label2 = "Actual Contribution Rate") {

  reasonTheme <- get("reasonTheme")
  var1 <- rlang::sym(.var1)
  var2 <- rlang::sym(.var2)

  graph <- data %>%
    dplyr::select(
      .data$year,
      v1 = !!var1,
      v2 = !!var2
    ) %>%
    dplyr::mutate_all(dplyr::funs(as.numeric)) %>%
    tidyr::gather(key = "keys", value = "amount", -.data$year)

  lineColors <- c("#FF6633","#333333")

  labs <- c(label1, label2)

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
