#' Grab a list of the plans with their state from the Reason database.
#'
#' @return A dataframe containing the pension plan id, name, and state.
#' @examples
#' planList()

planList <- function() {
  dw <- get("dw")
  # dw <- config::get(config = "datawarehouse")
  con <- RPostgres::dbConnect(
    RPostgres::Postgres(),
    dbname = trimws(dw$path),
    host = dw$hostname,
    port = dw$port,
    user = dw$username,
    password = dw$password,
    sslmode = "require"
  )

  # define the query to retrieve the plan list
  q1 <- "select plan.id,
  display_name,
  state.name as State
  from plan
  inner join government
  on plan.admin_gov_id = government.id
  inner join state
  on government.state_id = state.id
  order by state.name"

  # sends the query to the connection
  res <- RPostgres::dbSendQuery(con, q1)
  # fetches the results
  plans <- RPostgres::dbFetch(res)
  p_list <- plans %>%
    janitor::clean_names()
  # clears the results
  RPostgres::dbClearResult(res)
  # closes the connection
  RPostgres::dbDisconnect(con)
  p_list
}

####################################################################
# Description: This function pulls data for a selected plan from the Reason database.
# Parameters: pl is the variable containing the plan list returned by the planList() function.
#             The second parameter is the plan's name as found in the plan list.
# Usage: example: allData <- pullData(pl, "Kansas Public Employees' Retirement System")

pullData <-
  function(pl, plan_name = "Texas Employees Retirement System") {
    dw <- get("dw")
    #dw <- config::get("datawarehouse")
    con <- RPostgres::dbConnect(
      RPostgres::Postgres(),
      dbname = trimws(dw$path),
      host = dw$hostname,
      port = dw$port,
      user = dw$username,
      password = dw$password,
      sslmode = "require"
    )
    # define the query to retrieve the plan data
    query <- "select plan_annual_attribute.year,
  plan.id,
  plan.display_name,
  state.name as state,
  plan_attribute.name as attribute_name,
  plan_annual_attribute.attribute_value,
  data_source_id,
  data_source.name as data_source_name
  from plan_annual_attribute
  inner join plan
  on plan_annual_attribute.plan_id = plan.id
  inner join government
  on plan.admin_gov_id = government.id
  inner join state
  on government.state_id = state.id
  inner join plan_attribute
  on plan_annual_attribute.plan_attribute_id = plan_attribute.id
  inner join data_source
  on plan_attribute.data_source_id = data_source.id
  where cast(plan_annual_attribute.year as integer) >= 1980 and
  data_source_id <> 1 and
  plan_id = $1"

    plan_id <- pl$id[pl$display_name == plan_name]

    result <- RPostgres::dbSendQuery(con, query)
    RPostgres::dbBind(result, list(plan_id))
    all_data <- RPostgres::dbFetch(result) %>%
      janitor::clean_names()
    RPostgres::dbClearResult(result)
    RPostgres::dbDisconnect(con)
    all_data %>%
      dplyr::group_by_at(dplyr::vars(-.data$attribute_value)) %>%  # group by everything other than the value column.
      dplyr::mutate(row_id = 1:dplyr::n()) %>%
      dplyr::ungroup() %>%  # build group index
      tidyr::spread(.data, .data$attribute_name, .data$attribute_value, convert = TRUE) %>%    # spread
      dplyr::select(-.data$row_id) %>%  # drop the index
      janitor::clean_names()
  }

####################################################################
# Description: This function loads plan data from an Excel file
# Parameters: The filename including the path if in a subdirectory
# Usage: allWide <- loadData('data/NorthCarolina_PensionDatabase_TSERS.xlsx')

loadData <- function(filename) {
  readxl::read_excel(filename, col_types = "numeric") %>%
    janitor::clean_names()
}

####################################################################
# Description: This function selects the data used in the 'mountain of debt' graph
# Parameters:
#     wideData = a datasource in wide format
#     .year_var = the name of the column conatining the year
#     .aal_var = the name of the column containing the AAL, default is Reason db column name
#     .asset_var = the name of the column containing the Actuarial Assets, default to Reason db name.
#     base: Does the plan report their numbers by the thousand dollar or by the dollar?
#           default is 1000, change to 1 for plans that report by the dollar
# Usage: data <- modData(allWide,
#                   .year_var = 'Fiscal Year End',
#                   .aal_var = 'Actuarial Accrued Liability',
#                   .asset_var = 'Actuarial Value of Assets',
#                   base = 1)

modData <- function(wide_data,
  .year_var = "year",
  .aal_var = "actuarial_accrued_liabilities_under_gasb_standards",
  .asset_var = "actuarial_assets_under_gasb_standards",
  base = 1000){

  year_var <- rlang::sym(.year_var)
  aal_var <- rlang::sym(.aal_var)
  asset_var <- rlang::sym(.asset_var)

  wide_data %>%
    dplyr::select(year = !!year_var, actuarial_assets = !!asset_var, aal = !!aal_var) %>%
    dplyr::mutate(
      uaal = as.numeric(.data$aal) - as.numeric(.data$actuarial_assets),
      # create a UAAL column as AAL-Actuarial Assets
      funded_ratio = as.numeric(.data$actuarial_assets) / as.numeric(.data$aal),
      # create a fundedRatio column as Actuarial Assets divided by AAL
    ) %>%
    dplyr::mutate(
      actuarial_assets = as.numeric(.data$actuarial_assets) * base,
      aal = as.numeric(.data$aal) * base,
      uaal = .data$uaal * base
    ) %>%
    tidyr::drop_na()
}



####################################################################
# Description: This function creates the mountain of debt graph
# Parameters:
#     data: the dataframe created by the modData function
# Usage: modGraph(data)

modGraph <- function(data) {
  reasonTheme <- get("reasonTheme")
  # extrapolate between years linearly
  extrapo <- approx(data$year, data$uaal, n = 10000)
  extrapo2 <- approx(data$year, data$funded_ratio, n = 10000)
  graph <-
    data.frame(
      year = extrapo$x,
      uaal = extrapo$y,
      funded_ratio = extrapo2$y
    )
  # create a "negative-positive" column for fill aesthetic
  graph$sign[graph$uaal >= 0] <- "positive"
  graph$sign[graph$uaal < 0] <- "negative"

  ggplot2::ggplot(graph, ggplot2::aes(x = graph$year)) +
    # area graph using pos/neg for fill color
    ggplot2::geom_area(ggplot2::aes(y = graph$uaal, fill = graph$sign)) +
    # line tracing the area graph
    ggplot2::geom_line(ggplot2::aes(y = graph$uaal)) +
    # line with funded ratio
    ggplot2::geom_line(ggplot2::aes(y = graph$funded_ratio * (max(graph$uaal))), color = "#3300FF", size = 1) +
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
        scale = (1e-9),
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
    ggplot2::scale_x_continuous( # sets the years breaks to be every 2 years
      breaks = round(seq(min(graph$year), max(graph$year), by = 2), 1),
      expand = c(0, 0)
    ) +

    # adds the Reason theme defined previously
    reasonTheme
}

####################################################################
# Description: This function creates a data table containing the data in the mountain of debt graph.
# Parameters:
#     data: the dataframe created by the modData function
# Usage: modTable(data)

modTable <- function(data) {

  data <- data %>%
    # give the columns pretty names
    dplyr::rename(
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

####################################################################
# Description: This function creates a graph in the Gain/Loss format
# Parameters:
#     filename: the name of the file containing the gain/loss data
#     ylab: The y-axis label, default set
# Usage: glGraph(filename = 'data/Graph 1.csv')


glGraph <-
  function(filename, ylab = "Changes in Unfunded Liability (in Billions)") {
    reasonTheme <- get("reasonTheme")
    graph1 <- readr::read_csv(filename) %>% # load data from csv file
      tidyr::gather("label", "value") %>% # put in long format with label-value pairs
      dplyr::mutate(label = stringr::str_wrap(.data$label, 8)) %>% # wrap the label names to clean up axis labels
      dplyr::mutate(label = stringr::str_to_title(.data$label)) %>% # properly capitalize the labels
      # assign pos/neg/total to the values for fill color
      dplyr::mutate(sign = dplyr::case_when(.data$value >= 0 ~ "positive",
        .data$value < 0 ~ "negative")) %>%
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
      ggplot2::geom_col(width = 0.75, ggplot2::aes(fill = graph1$sign)) +
      ggplot2::geom_hline(yintercept = 0, color = "black") +
      ggplot2::scale_fill_manual(values = fill_colors) +
      ggplot2::scale_y_continuous(breaks = scales::pretty_breaks(), labels = scales::dollar_format(prefix = "$")) +
      ggplot2::ylab(ylab) +
      reasonTheme +
      ggplot2::theme(
        axis.line.x = ggplot2::element_blank(),
        axis.ticks.x = ggplot2::element_blank(),
        axis.text.x = ggplot2::element_text(angle = 0)
      )
  }

####################################################################
# Description: This function selects the data used in several graphs
# Parameters:
#     wideData = a datasource in wide format
#     .date_var = column name for valuation date. Default: 'Actuarial Valuation Date For GASB Assumptions',
#     .aal_var = column name AAL. Default: 'Actuarial Accrued Liabilities Under GASB Standards',
#     .asset_var = column name for Actuarial Assets. Default: 'Actuarial Assets under GASB standards',
#     .adec_var = column name for ADEC. Default: 'Employer Annual Required Contribution',
#     .emp_cont_var = column name for employer contributions. Default: 'Employer Contributions',
#     .payroll_var = column name for payroll. Default: 'Covered Payroll'
# Usage: data <- selected_Data(wideData,
#                   date_var = 'Actuarial Valuation Date For GASB Assumptions',
#                   aal_var = 'Actuarial Accrued Liabilities Under GASB Standards',
#                   asset_var = 'Actuarial Assets under GASB standards',
#                   adec_var = 'Employer Annual Required Contribution',
#                   emp_cont_var = 'Employer Contributions',
#                   payroll_var = 'Covered Payroll')


selectedData <- function(wide_data,
  .date_var = "actuarial_valuation_date_for_gasb_assumptions",
  .aal_var = "actuarial_accrued_liabilities_under_gasb_standards",
  .asset_var = "actuarial_assets_under_gasb_standards",
  .adec_var = "employer_annual_required_contribution",
  .emp_cont_var = "employer_contributions",
  .payroll_var = "covered_payroll") {

  date_var <- rlang::sym(.date_var)
  aal_var <- rlang::sym(.aal_var)
  asset_var <- rlang::sym(.asset_var)
  adec_var <- rlang::sym(.adec_var)
  emp_cont_var <- rlang::sym(.emp_cont_var)
  payroll_var <- rlang::sym(.payroll_var)

  wide_data %>%
    dplyr::mutate(
      date = !!date_var
    ) %>%
    dplyr::mutate(
      year = lubridate::year(janitor::excel_numeric_to_date(as.numeric(.data$date))),
      valuation_date = janitor::excel_numeric_to_date(as.numeric(.data$date))
    ) %>%
    dplyr::select(
      .data$year,
      .data$valuation_date,
      actuarial_assets = !!asset_var,
      aal = !!aal_var,
      adec = !!adec_var,
      emp_cont = !!emp_cont_var,
      payroll = !!payroll_var
    ) %>%
    dplyr::mutate(
      uaal = as.numeric(.data$aal) - as.numeric(.data$actuarial_assets),
      funded_ratio = as.numeric(.data$actuarial_assets) / as.numeric(.data$aal),
      adec_contribution_rates = as.numeric(.data$adec) / as.numeric(.data$payroll),
      actual_contribution_rates = as.numeric(.data$emp_cont) / as.numeric(.data$payroll)
    ) %>%
    tidyr::drop_na()
}

####################################################################
# Description: This function creates a graph comparing 2 percentages
# Parameters:
#     data: the dataframe created by the selected_Data function
# Usage: contGraph(data)

contGraph <- function(data,
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
    tidyr::gather(key = .data$keys, value = .data$amount, -.data$year)

  lineColors <- c(
    y1 = "#FF6633",
    y2 = "#3300FF",
    y3 = "#333333"
  )

  labs <- c(
    label1,
    label2,
    label3
  )

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
