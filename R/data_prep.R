#' Grab a list of the plans with their state from the Reason database.
#'
#' @return A dataframe containing the pension plan id, name, and state.
#' @examples
#' planList()
#' @export

planList <- function() {
  #dw <- get("dw")
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
    # janitor::clean_names() %>%
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
    #dw <- get("dw")
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
#' @return A data frame containing the columns: year, valuation_date, actuarial_assets, aal, adec, er_cont, ee_cont, payroll, uaal, funded_ratio, adec_contribution_rates, actual_contribution_rates
#' @export
#' @examples
#' \dontrun{
#' data <- selected_Data(wide_data)
#' }

selectedData <- function(wide_data) {

   wide_data %>%
    dplyr::select(
      year,
      plan_name = display_name,
      state,
      return_1yr = x1_year_investment_return_percentage,
      actuarial_cost_method_in_gasb_reporting,
      funded_ratio = actuarial_funded_ratio_percentage,
      actuarial_valuation_date_for_gasb_schedules,
      actuarial_valuation_report_date,
      ava = actuarial_value_of_assets_gasb_dollar,
      mva = market_value_of_assets_dollar,
      aal = actuarially_accrued_liabilities_dollar,
      tpl = total_pension_liability_dollar,
      adec = actuarially_required_contribution_dollar,
      adec_paid_pct = actuarially_required_contribution_paid_percentage,
      admin_exp = administrative_expense_dollar,
      amortizaton_method,
      asset_valuation_method_for_gasb_reporting,
      benefit_payments = benefit_payments_dollar,
      cost_structure,
      payroll = covered_payroll_dollar,
      ee_contribution = employee_contribution_dollar,
      ee_nc_pct = employee_normal_cost_percentage,
      er_contribution = employer_contribution_regular_dollar,
      er_nc_pct = employer_normal_cost_percentage,
      er_state_contribution = employer_state_contribution_dollar,
      er_proj_adec_pct = employers_projected_actuarial_required_contribution_percentage_of_payroll,
      fy = fiscal_year,
      fy_contribution = fiscal_year_of_contribution,
      inflation_assum = inflation_rate_assumption_for_gasb_reporting,
      arr = investment_return_assumption_for_gasb_reporting,
      number_of_years_remaining_on_amortization_schedule,
      payroll_growth_assumption,
      total_amortization_payment_pct = total_amortization_payment_percentage,
      total_contribution = total_contribution_dollar,
      total_nc_pct = total_normal_cost_percentage,
      total_number_of_members,
      total_proj_adec_pct = total_projected_actuarial_required_contribution_percentage_of_payroll,
      type_of_employees_covered,
      unfunded_actuarially_accrued_liabilities_dollar,
      wage_inflation
    ) %>%
    dplyr::filter(year > 2000) %>%
    mutate(
      valuation_date = janitor::excel_numeric_to_date(as.numeric(.data$actuarial_valuation_date_for_gasb_schedules))
    ) %>%
    dplyr::mutate(
      uaal = as.numeric(.data$aal) - as.numeric(.data$ava),
      funded_ratio_calc = as.numeric(.data$ava) / as.numeric(.data$aal),
      adec_contribution_rates = as.numeric(.data$adec) / as.numeric(.data$payroll),
      actual_contribution_rates = as.numeric(.data$er_contribution) / as.numeric(.data$payroll)
    )
}

