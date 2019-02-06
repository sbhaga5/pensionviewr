#' Create the 'Mountain of Debt' plot.
#' @param data a dataframe produced by the selectedData function or in the same format containing year, uaal, funded ratio columns.
#' @export
#' @examples
#' \dontrun{
#' debtPlot(data)
#' }
#' @importFrom rlang .data
debtPlot <- function(data) {
  data <- data %>%
    dplyr::filter(data$aal != 0)
  # extrapolate between years linearly
  extrapo <- stats::approx(data$year, data$uaal, n = 10000)
  extrapo2 <- stats::approx(data$year, data$funded_ratio, n = 10000)
  graph <-
    data.frame(year = extrapo$x,
      uaal = extrapo$y,
      funded_ratio = extrapo2$y) %>%
    tidyr::drop_na()

  # create a "negative-positive" column for fill aesthetic
  graph$sign[graph$uaal >= 0] <- "positive"
  graph$sign[graph$uaal < 0] <- "negative"

  ggplot2::ggplot(graph, ggplot2::aes(x = graph$year)) +
    # area graph using pos/neg for fill color
    ggplot2::geom_area(ggplot2::aes(y = graph$uaal, fill = graph$sign)) +
    # line tracing the area graph
    ggplot2::geom_line(ggplot2::aes(y = graph$uaal)) +
    # line with funded ratio
    ggplot2::geom_line(ggplot2::aes(y = graph$funded_ratio * (max(graph$uaal))),
      color = "#3300FF",
      size = 1) +
    # axis labels
    ggplot2::labs(y = "Unfunded Accrued Actuarial Liabilities", x = NULL) +

    # colors assigned to pos, neg
    ggplot2::scale_fill_manual(values = c("negative" = "#669900", "positive" = "#CC0000")) +

    # sets the y-axis scale
    ggplot2::scale_y_continuous(
      # creates 10 break points for labels
      breaks = scales::pretty_breaks(n = 10),
      # changes the format to be dollars, without cents, scaled to be in billions
      labels = scales::dollar_format(
        prefix = "$",
        scale = (1e-6),
        largest_with_cents = 1
      ),
      # defines the right side y-axis as a transformation of the left side axis, maximum UAAL = 100%, sets the breaks, labels
      sec.axis = ggplot2::sec_axis(
        ~ . / (max(graph$uaal) / 100),
        breaks = scales::pretty_breaks(n = 10),
        name = "Funded Ratio",
        labels = function(b) {
          paste0(round(b, 0), "%")
        }
      ),
      # removes the extra space so the fill is at the origin
      expand = c(0, 0)
    ) +

    # sets the x-axis scale
    ggplot2::scale_x_continuous(breaks = round(seq(min(graph$year), max(graph$year), by = 1), 1),
      expand = c(0, 0)) +

    # adds the Reason theme defined previously
    reasonStyle() +

    ggplot2::theme(legend.position = "none")
}


#' Create a table comntaining the data used in the 'Mountain of Debt' plot.
#' @param data a dataframe produced by the selectedData function or in the same format containing year, uaal, funded ratio columns.
#' @export
#' @examples
#' \dontrun{
#' debtTable(data)
#' }
debtTable <- function(data) {
  data <- data %>%
    # give the columns pretty names
    dplyr::select(
      "Year" = .data$year,
      "Actuarial Assets" = .data$actuarial_assets,
      "Actuarial Accrued Liabilities" = .data$aal,
      "Unfunded Actuarial Accrued Liabilities" = .data$uaal,
      "Funded Ratio" = .data$funded_ratio
    )
  # create a datatable
  DT::datatable(
    data,
    # add buttons for export, etc.
    extensions = c("Buttons"),
    # remove row names
    rownames = FALSE,
    # allow editing the table, experimenting with this one
    editable = TRUE,
    options = list(
      bPaginate = FALSE,
      scrollX = T,
      scrollY = "600px",
      dom = "Brt",
      buttons = list(
        "copy",
        list(
          extend = "csv",
          text = "csv",
          title = "MOD"
        ),
        list(
          extend = "excel",
          text = "Excel",
          title = "MOD"
        ),
        list(
          extend = "pdf",
          text = "pdf",
          title = "MOD"
        )
      )
    )
  ) %>%
    DT::formatCurrency(c(2:4)) %>%
    DT::formatPercentage(5, 2)
}
