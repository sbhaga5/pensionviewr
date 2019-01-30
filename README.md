
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pensionviewr

The goal of pensionviewr is to simplify the process of gathering and
visualizing public pension plan data from the Reason pension database.

## Installation

You can install the released version of pensionviewr from
[GitHub](https://github.com/ReasonFoundation/pensionviewr) with:

``` r
devtools::install_github("ReasonFoundation/pensionviewr")
```

## Usage:

The planList function returns a stripped down list of the pension plans
in the database along with their state and the internal databse id.

``` r
library(pensionviewr)
pl <- planList()
head(pl)
#>        id                                          display_name   state
#> 1       7        Alabama Clerks & Registrars Supernumerary Fund Alabama
#> 2       8            Jefferson County General Retirement System Alabama
#> 3 3400053            Dothan Employees Pension Retirement System Alabama
#> 4      12             Birmingham Unclassified Employees Pension Alabama
#> 5      21 Tuscaloosa Police & Fire Supplemental Retirement Plan Alabama
#> 6       2             Alabama Teachers' Retirement System (TRS) Alabama
```

The next step would be to load the data for the specific plan of
interest. Let’s use Kansas Public Employees’ Retirement System as an
example. Let’s first see what plans in Kansas are available:

``` r
require(tidyverse)
#> Loading required package: tidyverse
#> ── Attaching packages ────────────────────── tidyverse 1.2.1 ──
#> ✔ ggplot2 3.1.0     ✔ purrr   0.2.5
#> ✔ tibble  1.4.2     ✔ dplyr   0.7.8
#> ✔ tidyr   0.8.2     ✔ stringr 1.3.1
#> ✔ readr   1.3.0     ✔ forcats 0.3.0
#> ── Conflicts ───────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
KS <- pl %>% filter(state == 'Kansas')
print(KS)
#>         id
#> 1      793
#> 2  3396920
#> 3      802
#> 4      804
#> 5      799
#> 6      798
#> 7      800
#> 8      795
#> 9  3401515
#> 10 3407488
#> 11     794
#> 12     797
#> 13     801
#> 14 3396918
#> 15     803
#> 16     791
#> 17     790
#> 18     796
#> 19     792
#>                                                             display_name
#> 1                          Kansas Police and Firemen's Retirement System
#> 2        Supplemental Retirement Plan Topeka Uniform School District 501
#> 3                     Kansas City Board of Public Utilities Pension Plan
#> 4  Wichita Supplemental Annuity Business School Partnership Program 3547
#> 5                                     Leavenworth Firemen's Pension Fund
#> 6                                        Leavenworth Police Pension Fund
#> 7                                    Wichita Employees Retirement System
#> 8                                     Prarie Village Police Pension Plan
#> 9                      Retirement Pension Plan Board Of Public Utilities
#> 10                                   Atchison Public School Annuity Plan
#> 11                                   Lenexa Defined Benefit Pension Plan
#> 12                             Overland Park Police Dept Retirement Plan
#> 13                             Wichita Police and Fire Retirement System
#> 14                                Hutchinson Retirement Fund USD No. 308
#> 15             Johnson County Water District 1 Employees Retirement Plan
#> 16                                   Kansas Retirement System for Judges
#> 17                            Kansas Public Employees' Retirement System
#> 18                           Shawnee Employees Supplemental Pension Plan
#> 19      Kansas State Elected Officials Special Members Retirement System
#>     state
#> 1  Kansas
#> 2  Kansas
#> 3  Kansas
#> 4  Kansas
#> 5  Kansas
#> 6  Kansas
#> 7  Kansas
#> 8  Kansas
#> 9  Kansas
#> 10 Kansas
#> 11 Kansas
#> 12 Kansas
#> 13 Kansas
#> 14 Kansas
#> 15 Kansas
#> 16 Kansas
#> 17 Kansas
#> 18 Kansas
#> 19 Kansas
```

The full plan name we are interested in is there listed as “Kansas
Public Employees’ Retirement System”. We can pull the data for it
now:

``` r
kpers_data <- pullData(pl, plan_name = "Kansas Public Employees' Retirement System")
head(kpers_data)
#> # A tibble: 6 x 320
#>   year  id    display_name state data_source_id data_source_name
#>   <chr> <S3:> <chr>        <chr> <S3: integer6> <chr>           
#> 1 2001  790   Kansas Publ… Kans… 2              Pension Plan Da…
#> 2 2002  790   Kansas Publ… Kans… 2              Pension Plan Da…
#> 3 2003  790   Kansas Publ… Kans… 2              Pension Plan Da…
#> 4 2004  790   Kansas Publ… Kans… 2              Pension Plan Da…
#> 5 2005  790   Kansas Publ… Kans… 2              Pension Plan Da…
#> 6 2006  790   Kansas Publ… Kans… 2              Pension Plan Da…
#> # ... with 314 more variables: contributions_other_total <int>,
#> #   deductions_other_total <dbl>, investment_expense_total <dbl>,
#> #   net_increase_decrease_in_fair_value_of_total_investments <dbl>,
#> #   percent_of_assets_invested_in_misc_alternatives <dbl>,
#> #   targeted_percent_of_assets_invested_in_equity_investments_tot <dbl>,
#> #   total_fund_benchmark_return <chr>, x1_yr_investment_return <dbl>,
#> #   x10_year_return_average <dbl>, x10_yr_investment_return <dbl>,
#> #   x12_yr_investment_return <int>, x15_yr_investment_return <int>,
#> #   x2_yr_investment_return <int>, x20_yr_investment_return <int>,
#> #   x25_yr_investment_return <dbl>, x3_year_return_average <dbl>,
#> #   x3_yr_investment_return <dbl>, x30_yr_investment_return <int>,
#> #   x4_yr_investment_return <int>, x5_year_return_average <dbl>,
#> #   x5_yr_investment_return <dbl>, x7_yr_investment_return <int>,
#> #   x8_yr_investment_return <int>,
#> #   actuarial_accrued_liabilities_under_gasb_standards <dbl>,
#> #   actuarial_assets <int>,
#> #   actuarial_assets_reported_for_asset_smoothing <dbl>,
#> #   actuarial_assets_under_gasb_standards <dbl>,
#> #   actuarial_cost_method_code_names <int>,
#> #   actuarial_cost_method_code_names_for_gasb <int>,
#> #   actuarial_cost_method_for_gasb_reporting <chr>,
#> #   actuarial_cost_method_for_plan_reporting <lgl>,
#> #   actuarial_cost_method_notes <lgl>,
#> #   actuarial_funded_ratio_gasb_67 <dbl>,
#> #   actuarial_liabilities_under_entry_age_normal <dbl>,
#> #   actuarial_liabilities_under_projected_unit_credit <int>,
#> #   actuarial_report_calendar_year <int>,
#> #   actuarial_valuation_date_for_actuarial_costs <chr>,
#> #   actuarial_valuation_date_for_gasb_assumptions <int>,
#> #   actuarial_valuation_date_for_gasb_schedules <int>,
#> #   actuarial_valuation_report_date <int>,
#> #   actuarially_determined_contribution <int>,
#> #   actuarially_required_contribution <dbl>,
#> #   administering_government_type <int>,
#> #   administrating_jurisdiction <chr>, aec <int>,
#> #   alternatives_expense <int>, alternatives_income <int>,
#> #   amortizaton_method <chr>, annual_return_on_cash_investments <dbl>,
#> #   annual_return_on_commodity_investments <dbl>,
#> #   annual_return_on_fixed_income_investments <dbl>,
#> #   annual_return_on_hedge_fund_investments <int>,
#> #   annual_return_on_misc_alternative_investments <dbl>,
#> #   annual_return_on_other_investments <int>,
#> #   annual_return_on_private_equity_investments <dbl>,
#> #   annual_return_on_real_estate_investments <dbl>,
#> #   annual_return_on_total_equity_investments <dbl>,
#> #   are_most_members_covered_by_social_security <int>,
#> #   asset_smoothing_baseline <int>,
#> #   asset_smoothing_baseline_add_or_subtract_gain_loss <int>,
#> #   asset_smoothing_period_for_gasb_reporting <int>,
#> #   asset_valuation_method_code_for_gasb_reporting <int>,
#> #   asset_valuation_method_code_for_plan_reporting <int>,
#> #   asset_valuation_method_for_gasb_reporting <chr>,
#> #   asset_valuation_method_for_plan_reporting <lgl>,
#> #   asset_valuation_method_note <lgl>,
#> #   average_age_at_retirement_for_service_retirees <int>,
#> #   average_age_of_actives <dbl>, average_age_of_beneficiaries <dbl>,
#> #   average_age_of_service_retirees <dbl>,
#> #   average_annual_benefit_at_retirement_for_service_retirees <lgl>,
#> #   average_benefit_of_beneficiaries <dbl>,
#> #   average_benefit_paid_to_service_retirees <dbl>,
#> #   average_salary_of_actives <dbl>,
#> #   average_tenure_at_retirement_for_service_retirees <int>,
#> #   average_tenure_of_actives <dbl>, beginning_market_assets_net <dbl>,
#> #   benefits_website <chr>, blended_discount_rate <dbl>,
#> #   cafr_calendar_year <int>, closed_plan <int>, cola_code <lgl>,
#> #   cola_provsion_text <lgl>,
#> #   confict_between_cafr_and_actuarial_valuation <lgl>,
#> #   contributions_employer_total <dbl>,
#> #   contributions_other_employer <int>, contributions_other_member <int>,
#> #   cost_sharing <int>, cost_structure <chr>, covered_payroll <dbl>,
#> #   covered_payroll_gasb_67 <int>, covers_elected_officials <int>,
#> #   covers_local_employees <int>, covers_local_fire_fighters <int>,
#> #   covers_local_general_employees <int>,
#> #   covers_local_police_officers <int>, covers_state_employees <int>,
#> #   covers_state_fire_employees <int>,
#> #   covers_state_general_employees <int>,
#> #   covers_state_police_employees <int>, …
```

That is a lot of variables. The selectedData() function selects only a
handful of needed variables:

``` r
df <- selectedData(kpers_data)
head(df)
#> # A tibble: 6 x 12
#>    year valuation_date actuarial_assets    aal   adec er_cont ee_cont
#>   <dbl> <date>                    <dbl>  <dbl>  <dbl>   <dbl>   <dbl>
#> 1  2000 2000-12-31              9835182 1.11e7 2.49e5 193384. 204143.
#> 2  2001 2001-12-31              9962918 1.17e7 2.60e5 221474. 209624.
#> 3  2002 2002-12-31              9784862 1.26e7 2.82e5 231464. 224746.
#> 4  2003 2003-12-31             10853462 1.44e7 3.39e5 714353. 230350.
#> 5  2004 2004-12-31             10971427 1.57e7 3.82e5 293952. 233226.
#> 6  2005 2005-12-31             11339293 1.65e7 4.71e5 352032. 246203.
#> # ... with 5 more variables: payroll <dbl>, uaal <dbl>,
#> #   funded_ratio <dbl>, adec_contribution_rates <dbl>,
#> #   actual_contribution_rates <dbl>
```

Now lets make some plots:

<img src="man/figures/README-plot1-1.png" width="100%" />

``` r
linePlot(df)
```

<img src="man/figures/README-contributions-1.png" width="100%" />
