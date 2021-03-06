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
  labelY = "Employer Contribution (% of Payroll)",
  label1 = "ADEC Contribution Rate",
  label2 = "Actual Contribution Rate") {

  var1 <- rlang::sym(.var1)
  var2 <- rlang::sym(.var2)
  lab1 <- rlang::sym(label1)
  lab2 <- rlang::sym(label2)

  reasontheme::set_reason_theme(style = "slide")

  graph <- data %>%
    dplyr::select(
      .data$year,
      !!label1 := !!var1,
      !!label2 := !!var2
    ) %>%
    dplyr::mutate_all(dplyr::funs(as.numeric)) %>%
    tidyr::gather(key = "keys", value = "amount", -.data$year)

  lineColors <- c("#999999","#0066CC")

  ggplot2::ggplot(graph, ggplot2::aes(x = graph$year, y = graph$amount * 100)) +
    ggplot2::geom_line(ggplot2::aes(colour = factor(graph$keys)), size = 2) +
    ggplot2::scale_colour_manual(values = lineColors) +
    ggplot2::geom_hline(yintercept = 0, color = "black") +

    ggplot2::scale_y_continuous(
      breaks = scales::pretty_breaks(10),
      labels = function(b) {
        paste0(round(b, 0), "%")
      },
      expand = c(0, 0)
    ) +

    ggplot2::scale_x_continuous(breaks = graph$year,
        expand = c(0, 0)
      ) +

    labs(x = element_blank(), y = labelY)

}
