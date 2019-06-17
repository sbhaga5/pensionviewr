#' Create the 'Gain/Loss' plot using a file as an input.
#'
#' @param filename a csv (comma separated value) file containing columns of gain loss category names with one row of values.
#' @param ylab_unit a string contained within quotation marks containing th y-axis label unit. The default value is "Billions"
#' @importFrom rlang .data
#' @export
#' @examples
#' \dontrun{
#' glPlot(filename = 'data/Graph 1.csv')
#' glPlot(filename = 'data/Graph 2.csv', ylab = "Millions")
#' glPlot(filename = 'data/Graph 2.csv', ylab = "millions")
#' }
glPlot <-
  function(filename, ylab_unit = "Billions") {
    ylab <- paste0("Changes in Unfunded Liabilities (in ", stringr::str_to_title(ylab_unit),")")
    graph1 <- readr::read_csv(filename) %>%
      tidyr::gather("label", "value") %>%
      dplyr::mutate(label = stringr::str_wrap(.data$label, 8)) %>%
      # wrap the label names to clean up axis labels
      dplyr::mutate(label = stringr::str_to_title(.data$label)) %>%
      # properly capitalize the labels
      dplyr::mutate(sign = dplyr::case_when(.data$value >= 0 ~ "positive",
        .data$value < 0 ~ "negative")) %>%
      # assign pos/neg/total to the values for fill color
      dplyr::mutate(sign = dplyr::case_when(.data$label == "Total" ~ "total", TRUE ~ .data$sign)) %>%
      dplyr::mutate(sign = factor(.data$sign, levels = c("total", "negative", "positive"))) %>%
      dplyr::mutate(label = factor(.data$label, levels = .data$label[order(.data$sign, .data$value, .data$label, decreasing = TRUE)], ordered = TRUE))

    # assign colors to go with signs
    fill_colors <- c(
      "negative" = "#669900",
      "positive" = "#CC0000",
      "total" = "#FF6633"
    )

    # create plot
    ggplot2::ggplot(graph1, ggplot2::aes(x = graph1$label, y = graph1$value)) +
      ggplot2::geom_col(width = 0.75, ggplot2::aes(fill = graph1$sign), color = "black") +
      ggplot2::geom_hline(yintercept = 0, color = "black") +
      ggplot2::scale_fill_manual(values = fill_colors) +
      ggplot2::scale_y_continuous(breaks = scales::pretty_breaks(5), labels = scales::dollar_format(prefix = "$")) +
      ggplot2::ylab(ylab) +
      reasontheme::reasonStyle() +
      ggplot2::theme(
        legend.position = "none",
        axis.ticks.x = ggplot2::element_blank(),
        axis.text.x = ggplot2::element_text(angle = 0),
        axis.title.x = ggplot2::element_blank()
      )
  }
