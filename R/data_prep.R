#' Grab a list of the plans with their state from the Reason database.
#'
#' @return A dataframe containing the pension plan id, name, and state.
#' @examples
#' planList()
#' @export

planList <- function() {
  dw <- get("dw")
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
    janitor::clean_names() %>%
    dplyr::arrange(.data$state, .data$display_name)
  # clears the results
  RPostgres::dbClearResult(res)
  # closes the connection
  RPostgres::dbDisconnect(con)
  p_list
}


#' Pull the data for a specified plan from the Reason pension databse.
#'
#' @param pl A datafram containing the list of plan names, states, and ids in the form produced by the planList() function.
#' @param plan_name A string enclosed in quotation marks containing a plan name as it is listed in the Reason pension database.
#' @return A wide data frame with each year as a row and variables as columns.
#' @export
#' @importFrom rlang .data
#' @examples
#' \dontrun{
#' pullData(pl)
#' pullData(pl, "Kansas Public Employees' Retirement System")
#' }
pullData <-
  function(pl, plan_name = "Texas Employees Retirement System") {
    dw <- get("dw")
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
    query <- "select plan_annual_master_attribute.year,
  plan_annual_master_attribute.plan_id,
  plan.display_name,
  state.name as state,
  plan_master_attribute_names.name as attribute_name,
  plan_annual_master_attribute.attribute_value
  from plan_annual_master_attribute
  inner join plan
  on plan_annual_master_attribute.plan_id = plan.id
  inner join government
  on plan.admin_gov_id = government.id
  inner join state
  on government.state_id = state.id
  inner join plan_master_attribute_names
  on plan_annual_master_attribute.master_attribute_id = plan_master_attribute_names.id
  where plan_id = $1"

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
      tidyr::spread(.data$attribute_name, .data$attribute_value, convert = TRUE) %>%    # spread
      dplyr::select(-.data$row_id) %>%  # drop the index
      janitor::clean_names()
  }


#' Load the data for a specified plan from an Excel file.
#'
#' @param filename A string enclosed in quotation marks containing a file name with path of a pension plan Excel data file.
#' @export
#' @examples
#' \dontrun{
#' allWide <- loadData('data/NorthCarolina_PensionDatabase_TSERS.xlsx')
#' }
loadData <- function(filename) {
  readxl::read_excel(filename, col_types = "numeric") %>%
    janitor::clean_names()
}

#' Selects the data used in several graphs.
#'
#' @param wide_data a datasource in wide format
#' @param .date_var column name for valuation date. Default: 'Actuarial Valuation Date For GASB Assumptions'
#' @param .aal_var column name AAL. Default: 'Actuarial Accrued Liabilities Under GASB Standards'
#' @param .mva_var column name for Market Value of Assets. Default: 'beginning_market_assets_net'
#' @param .ava_var column name for Actuarial Assets. Default: 'Actuarial Assets under GASB standards'
#' @param .adec_var column name for ADEC. Default: 'Employer Annual Required Contribution'
#' @param .tpl_var column name for Total Pension Liability. Default: "total_pension_liability",
#' @param .er_cont_var column name for employer contributions. Default: 'Employer Contributions'
#' @param .ee_cont_var column name for employee contributions. Default: 'Employee Contributions'
#' @param .payroll_var column name for payroll. Default: 'Covered Payroll'
#' @param .arr_var column name for the Assumed Rate of Return. Default: 'investment_return_assumption_for_gasb_reporting'
#' @return A data frame containing the columns: year, valuation_date, actuarial_assets, aal, adec, er_cont, ee_cont, payroll, uaal, funded_ratio, adec_contribution_rates, actual_contribution_rates
#' @export
#' @examples
#' \dontrun{
#' data <- selected_Data(wide_data,
#'                  .date_var = 'Actuarial Valuation Date For GASB Assumptions',
#'                  .aal_var = 'Actuarial Accrued Liabilities Under GASB Standards',
#'                  .mva_var = 'beginning_market_assets_net',
#'                  .ava_var = 'Actuarial Assets under GASB standards',
#'                  .tpl_var = 'total_pension_liability',
#'                  .adec_var = 'Employer Annual Required Contribution',
#'                  .er_cont_var = 'Employer Contributions',
#'                  .ee_cont_var = 'Employer Contributions',
#'                  .payroll_var = 'Covered Payroll',
#'                  .arr_var = 'investment_return_assumption_for_gasb_reporting'
#'                  )
#' }

selectedData <- function(wide_data,
  .date_var = "actuarial_valuation_date_for_gasb_assumptions",
  .aal_var = "actuarial_accrued_liabilities_under_gasb_standards",
  .mva_var = "beginning_market_assets_net",
  .ava_var = "actuarial_assets_under_gasb_standards",
  .tpl_var = "total_pension_liability",
  .adec_var = "employer_annual_required_contribution",
  .er_cont_var = "employer_contributions",
  .ee_cont_var = "employee_contributions",
  .payroll_var = "covered_payroll",
  .arr_var = "investment_return_assumption_for_gasb_reporting") {

  date_var <- rlang::sym(.date_var)
  aal_var <- rlang::sym(.aal_var)
  mva_var <- rlang::sym(.mva_var)
  ava_var <- rlang::sym(.ava_var)
  tpl_var <- rlang::sym(.tpl_var)
  adec_var <- rlang::sym(.adec_var)
  er_cont_var <- rlang::sym(.er_cont_var)
  ee_cont_var <- rlang::sym(.ee_cont_var)
  payroll_var <- rlang::sym(.payroll_var)
  arr_var <- rlang::sym(.arr_var)

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
      market_value_assets = !!mva_var,
      actuarial_assets = !!ava_var,
      aal = !!aal_var,
      tpl = !!tpl_var,
      adec = !!adec_var,
      er_cont = !!er_cont_var,
      ee_cont = !!ee_cont_var,
      payroll = !!payroll_var,
      assumed_rate_of_return = !!arr_var
    ) %>%
    dplyr::mutate(
      uaal = as.numeric(.data$aal) - as.numeric(.data$actuarial_assets),
      funded_ratio = as.numeric(.data$actuarial_assets) / as.numeric(.data$aal),
      adec_contribution_rates = as.numeric(.data$adec) / as.numeric(.data$payroll),
      actual_contribution_rates = as.numeric(.data$er_cont) / as.numeric(.data$payroll)
    ) %>%
    tidyr::drop_na()
}

