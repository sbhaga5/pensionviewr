#' Grab a list of the plans with their state from the Reason database.
#'
#' @return A dataframe containing the pension plan id, name, and state.
#' @examples
#' planList()
#' @export

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
  data_source_id = 2 and
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
#' @param .asset_var column name for Actuarial Assets. Default: 'Actuarial Assets under GASB standards'
#' @param .adec_var column name for ADEC. Default: 'Employer Annual Required Contribution'
#' @param .emp_cont_var column name for employer contributions. Default: 'Employer Contributions'
#' @param .payroll_var column name for payroll. Default: 'Covered Payroll'
#' @return A data frame containing the columns: year, valuation_date, actuarial_assets, aal, adec, emp_cont, payroll, uaal, funded_ratio, adec_contribution_rates, actual_contribution_rates
#' @export
#' @examples
#' \dontrun{
#' data <- selected_Data(wide_data,
#'                  date_var = 'Actuarial Valuation Date For GASB Assumptions',
#'                  aal_var = 'Actuarial Accrued Liabilities Under GASB Standards',
#'                  asset_var = 'Actuarial Assets under GASB standards',
#'                  adec_var = 'Employer Annual Required Contribution',
#'                  emp_cont_var = 'Employer Contributions',
#'                  payroll_var = 'Covered Payroll'
#'                  )
#' }

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

