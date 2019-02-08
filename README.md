
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pensionviewr

The goal of `pensionviewr` is to simplify the process of gathering and
visualizing public pension plan data from the Reason pension database.
This repo contains the functions of the `pensionviewr` package, which
once installed locally, provides helpful functions for creating and
exporting graphics made in ggplot in the style used by the Reason
Pension Integrity Project team.

## Installing pensionviewr

`pensionviewr` is not on CRAN, so you will have to install it directly
from Github using `devtools`.

`devtools` calls the GitHub API (Application Programming Interface). And
this requires that you authenticate yourself in a different way than the
usual username and password. For the GitHub API, we use a personal
access token (PAT), which is a convention followed by many other APIs.

### Step-by-step

source: <https://happygitwithr.com/github-pat.html>

Login to your GitHub account. Go to
<https://github.com/settings/tokens>.

“Generate new token”. Give it a nickname that reminds you of the
intended purpose, e.g., “devtools”.

Pick scopes that confer the privileges you need. When in doubt, check
the repo scope, which is required for typical devtools operations. There
used to be a set of default scopes, but that no longer appears to be
true.

After you click “Generate token”, the token will be displayed. It’s a
string of 40 random letters and digits. This is the last time you will
see it SO COPY IT TO THE CLIPBOARD. Leave this window open until you’re
done. If you somehow goof this up, just generate a new one and try
again.

Put your PAT in your .Renviron file. Have a line that looks like this:

    GITHUB_PAT=8c70fd8419398999c9ac5bacf3192882193cadf2

but with your PAT instead of mine. Don’t worry, I’ve revoked this one\!

`.Renviron` is a hidden file that lives in your home directory. Not sure
where that is? The easiest way to find and edit `.Renviron` is with a
function from the `usethis` package. In R, do:

    usethis::edit_r_environ()

Your `.Renviron` file should pop up in your editor. Add your GITHUB\_PAT
as above, save and close it.

Put a line break at the end.

Restart R (Session \> Restart R in the RStudio menu bar), as environment
variables are loaded from `.Renviron` only at the start of an R session.
Check that the PAT is now available like so:

    Sys.getenv("GITHUB_PAT")

You should see your PAT print to screen.

Now commands you run from the `devtools` package, which consults
`GITHUB_PAT` by default, will be able to access private GitHub
repositories to which you have access.

If you do not have the `devtools` package installed, you will have to
run the first line in the code below as well.

``` r
install.packages('devtools')
devtools::install_github("ReasonFoundation/pensionviewr")
```

## Using the functions:

The package has four functions for data pulling and preparation:
`planList()`, `pullData()`, `loadData()`, and `selectedData()`.

The package has five functions for plots: `reasonStyle()`, `glPlot()`,
`linePlot()`, `debtPlot()`, and `savePlot()`.

A basic explanation and summary here:

### `planList()`

1.  `planList()`: returns a stripped down list of the pension plans in
    the database along with their state and the internal databse id.

Example of how it is used in a standard workflow:

``` r
pl <- planList()
pl %>% 
  head() %>%
  kable() %>%
  kable_styling(full_width = FALSE, position = "left")
```

<table class="table" style="width: auto !important; ">

<thead>

<tr>

<th style="text-align:right;">

id

</th>

<th style="text-align:left;">

display\_name

</th>

<th style="text-align:left;">

state

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:right;">

7

</td>

<td style="text-align:left;">

Alabama Clerks & Registrars Supernumerary Fund

</td>

<td style="text-align:left;">

Alabama

</td>

</tr>

<tr>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

Alabama Employees’ Retirement System (ERS)

</td>

<td style="text-align:left;">

Alabama

</td>

</tr>

<tr>

<td style="text-align:right;">

3

</td>

<td style="text-align:left;">

Alabama Judicial Retirement Fund (JRF)

</td>

<td style="text-align:left;">

Alabama

</td>

</tr>

<tr>

<td style="text-align:right;">

4

</td>

<td style="text-align:left;">

Alabama Peace Officers Annuity Benefit Fund

</td>

<td style="text-align:left;">

Alabama

</td>

</tr>

<tr>

<td style="text-align:right;">

5

</td>

<td style="text-align:left;">

Alabama Port Authority Hourly Pension Plan

</td>

<td style="text-align:left;">

Alabama

</td>

</tr>

<tr>

<td style="text-align:right;">

6

</td>

<td style="text-align:left;">

Alabama Port Authority Terminal Railway Plan

</td>

<td style="text-align:left;">

Alabama

</td>

</tr>

</tbody>

</table>

### `pullData()`

2.  `pullData()`: pulls the data for a specified plan from the Reason
    pension databse. `pullData` has two arguments: `pullData(pl,
    plan_name)`

<!-- end list -->

  - `pl`: A datafram containing the list of plan names, states, and ids
    in the form produced by the `planList()` function.
  - `plan_name`: A string enclosed in quotation marks containing a plan
    name as it is listed in the Reason pension database.

Example of how it is used in a standard workflow:

The next step would be to load the data for the specific plan of
interest. Let’s use Kansas Public Employees’ Retirement System as an
example. Let’s first see what plans in Kansas are available:

``` r
KS <- pl %>% filter(state == 'Kansas')
KS %>% 
  head() %>%
  kable() %>%
  kable_styling(full_width = FALSE, position = "left")
```

<table class="table" style="width: auto !important; ">

<thead>

<tr>

<th style="text-align:right;">

id

</th>

<th style="text-align:left;">

display\_name

</th>

<th style="text-align:left;">

state

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:right;">

3407488

</td>

<td style="text-align:left;">

Atchison Public School Annuity Plan

</td>

<td style="text-align:left;">

Kansas

</td>

</tr>

<tr>

<td style="text-align:right;">

3396918

</td>

<td style="text-align:left;">

Hutchinson Retirement Fund USD No. 308

</td>

<td style="text-align:left;">

Kansas

</td>

</tr>

<tr>

<td style="text-align:right;">

803

</td>

<td style="text-align:left;">

Johnson County Water District 1 Employees Retirement Plan

</td>

<td style="text-align:left;">

Kansas

</td>

</tr>

<tr>

<td style="text-align:right;">

802

</td>

<td style="text-align:left;">

Kansas City Board of Public Utilities Pension Plan

</td>

<td style="text-align:left;">

Kansas

</td>

</tr>

<tr>

<td style="text-align:right;">

793

</td>

<td style="text-align:left;">

Kansas Police and Firemen’s Retirement System

</td>

<td style="text-align:left;">

Kansas

</td>

</tr>

<tr>

<td style="text-align:right;">

790

</td>

<td style="text-align:left;">

Kansas Public Employees’ Retirement System

</td>

<td style="text-align:left;">

Kansas

</td>

</tr>

</tbody>

</table>

The full plan name we are interested in is there listed as “Kansas
Public Employees’ Retirement System”. We can pull the data for it
now:

``` r
kpers_data <- pullData(pl, plan_name = "Kansas Public Employees' Retirement System")
kpers_data %>% 
  head() %>%
  kable() %>%
  kable_styling(full_width = FALSE, position = "left")
```

<table class="table" style="width: auto !important; ">

<thead>

<tr>

<th style="text-align:left;">

year

</th>

<th style="text-align:right;">

id

</th>

<th style="text-align:left;">

display\_name

</th>

<th style="text-align:left;">

state

</th>

<th style="text-align:right;">

data\_source\_id

</th>

<th style="text-align:left;">

data\_source\_name

</th>

<th style="text-align:right;">

contributions\_other\_total

</th>

<th style="text-align:right;">

deductions\_other\_total

</th>

<th style="text-align:right;">

investment\_expense\_total

</th>

<th style="text-align:right;">

net\_increase\_decrease\_in\_fair\_value\_of\_total\_investments

</th>

<th style="text-align:right;">

percent\_of\_assets\_invested\_in\_misc\_alternatives

</th>

<th style="text-align:right;">

targeted\_percent\_of\_assets\_invested\_in\_equity\_investments\_tot

</th>

<th style="text-align:left;">

total\_fund\_benchmark\_return

</th>

<th style="text-align:right;">

x1\_yr\_investment\_return

</th>

<th style="text-align:right;">

x10\_year\_return\_average

</th>

<th style="text-align:right;">

x10\_yr\_investment\_return

</th>

<th style="text-align:right;">

x12\_yr\_investment\_return

</th>

<th style="text-align:right;">

x15\_yr\_investment\_return

</th>

<th style="text-align:right;">

x2\_yr\_investment\_return

</th>

<th style="text-align:right;">

x20\_yr\_investment\_return

</th>

<th style="text-align:right;">

x25\_yr\_investment\_return

</th>

<th style="text-align:right;">

x3\_year\_return\_average

</th>

<th style="text-align:right;">

x3\_yr\_investment\_return

</th>

<th style="text-align:right;">

x30\_yr\_investment\_return

</th>

<th style="text-align:right;">

x4\_yr\_investment\_return

</th>

<th style="text-align:right;">

x5\_year\_return\_average

</th>

<th style="text-align:right;">

x5\_yr\_investment\_return

</th>

<th style="text-align:right;">

x7\_yr\_investment\_return

</th>

<th style="text-align:right;">

x8\_yr\_investment\_return

</th>

<th style="text-align:right;">

actuarial\_accrued\_liabilities\_under\_gasb\_standards

</th>

<th style="text-align:right;">

actuarial\_assets

</th>

<th style="text-align:right;">

actuarial\_assets\_reported\_for\_asset\_smoothing

</th>

<th style="text-align:right;">

actuarial\_assets\_under\_gasb\_standards

</th>

<th style="text-align:right;">

actuarial\_cost\_method\_code\_names

</th>

<th style="text-align:right;">

actuarial\_cost\_method\_code\_names\_for\_gasb

</th>

<th style="text-align:left;">

actuarial\_cost\_method\_for\_gasb\_reporting

</th>

<th style="text-align:left;">

actuarial\_cost\_method\_for\_plan\_reporting

</th>

<th style="text-align:left;">

actuarial\_cost\_method\_notes

</th>

<th style="text-align:right;">

actuarial\_funded\_ratio\_gasb\_67

</th>

<th style="text-align:right;">

actuarial\_liabilities\_under\_entry\_age\_normal

</th>

<th style="text-align:right;">

actuarial\_liabilities\_under\_projected\_unit\_credit

</th>

<th style="text-align:right;">

actuarial\_report\_calendar\_year

</th>

<th style="text-align:left;">

actuarial\_valuation\_date\_for\_actuarial\_costs

</th>

<th style="text-align:right;">

actuarial\_valuation\_date\_for\_gasb\_assumptions

</th>

<th style="text-align:right;">

actuarial\_valuation\_date\_for\_gasb\_schedules

</th>

<th style="text-align:right;">

actuarial\_valuation\_report\_date

</th>

<th style="text-align:right;">

actuarially\_determined\_contribution

</th>

<th style="text-align:right;">

actuarially\_required\_contribution

</th>

<th style="text-align:right;">

administering\_government\_type

</th>

<th style="text-align:left;">

administrating\_jurisdiction

</th>

<th style="text-align:right;">

aec

</th>

<th style="text-align:right;">

alternatives\_expense

</th>

<th style="text-align:right;">

alternatives\_income

</th>

<th style="text-align:left;">

amortizaton\_method

</th>

<th style="text-align:right;">

annual\_return\_on\_cash\_investments

</th>

<th style="text-align:right;">

annual\_return\_on\_commodity\_investments

</th>

<th style="text-align:right;">

annual\_return\_on\_fixed\_income\_investments

</th>

<th style="text-align:right;">

annual\_return\_on\_hedge\_fund\_investments

</th>

<th style="text-align:right;">

annual\_return\_on\_misc\_alternative\_investments

</th>

<th style="text-align:right;">

annual\_return\_on\_other\_investments

</th>

<th style="text-align:right;">

annual\_return\_on\_private\_equity\_investments

</th>

<th style="text-align:right;">

annual\_return\_on\_real\_estate\_investments

</th>

<th style="text-align:right;">

annual\_return\_on\_total\_equity\_investments

</th>

<th style="text-align:right;">

are\_most\_members\_covered\_by\_social\_security

</th>

<th style="text-align:right;">

asset\_smoothing\_baseline

</th>

<th style="text-align:right;">

asset\_smoothing\_baseline\_add\_or\_subtract\_gain\_loss

</th>

<th style="text-align:right;">

asset\_smoothing\_period\_for\_gasb\_reporting

</th>

<th style="text-align:right;">

asset\_valuation\_method\_code\_for\_gasb\_reporting

</th>

<th style="text-align:right;">

asset\_valuation\_method\_code\_for\_plan\_reporting

</th>

<th style="text-align:left;">

asset\_valuation\_method\_for\_gasb\_reporting

</th>

<th style="text-align:left;">

asset\_valuation\_method\_for\_plan\_reporting

</th>

<th style="text-align:left;">

asset\_valuation\_method\_note

</th>

<th style="text-align:right;">

average\_age\_at\_retirement\_for\_service\_retirees

</th>

<th style="text-align:right;">

average\_age\_of\_actives

</th>

<th style="text-align:right;">

average\_age\_of\_beneficiaries

</th>

<th style="text-align:right;">

average\_age\_of\_service\_retirees

</th>

<th style="text-align:left;">

average\_annual\_benefit\_at\_retirement\_for\_service\_retirees

</th>

<th style="text-align:right;">

average\_benefit\_of\_beneficiaries

</th>

<th style="text-align:right;">

average\_benefit\_paid\_to\_service\_retirees

</th>

<th style="text-align:right;">

average\_salary\_of\_actives

</th>

<th style="text-align:right;">

average\_tenure\_at\_retirement\_for\_service\_retirees

</th>

<th style="text-align:right;">

average\_tenure\_of\_actives

</th>

<th style="text-align:right;">

beginning\_market\_assets\_net

</th>

<th style="text-align:left;">

benefits\_website

</th>

<th style="text-align:right;">

blended\_discount\_rate

</th>

<th style="text-align:right;">

cafr\_calendar\_year

</th>

<th style="text-align:right;">

closed\_plan

</th>

<th style="text-align:left;">

cola\_code

</th>

<th style="text-align:left;">

cola\_provsion\_text

</th>

<th style="text-align:left;">

confict\_between\_cafr\_and\_actuarial\_valuation

</th>

<th style="text-align:right;">

contributions\_employer\_total

</th>

<th style="text-align:right;">

contributions\_other\_employer

</th>

<th style="text-align:right;">

contributions\_other\_member

</th>

<th style="text-align:right;">

cost\_sharing

</th>

<th style="text-align:left;">

cost\_structure

</th>

<th style="text-align:right;">

covered\_payroll

</th>

<th style="text-align:right;">

covered\_payroll\_gasb\_67

</th>

<th style="text-align:right;">

covers\_elected\_officials

</th>

<th style="text-align:right;">

covers\_local\_employees

</th>

<th style="text-align:right;">

covers\_local\_fire\_fighters

</th>

<th style="text-align:right;">

covers\_local\_general\_employees

</th>

<th style="text-align:right;">

covers\_local\_police\_officers

</th>

<th style="text-align:right;">

covers\_state\_employees

</th>

<th style="text-align:right;">

covers\_state\_fire\_employees

</th>

<th style="text-align:right;">

covers\_state\_general\_employees

</th>

<th style="text-align:right;">

covers\_state\_police\_employees

</th>

<th style="text-align:right;">

covers\_teachers

</th>

<th style="text-align:right;">

current\_gain\_loss\_amount

</th>

<th style="text-align:left;">

data\_entry\_code

</th>

<th style="text-align:left;">

data\_source\_for\_actuarial\_costs

</th>

<th style="text-align:left;">

data\_source\_for\_gasb\_schedules

</th>

<th style="text-align:left;">

data\_source\_for\_income\_statement

</th>

<th style="text-align:left;">

data\_source\_for\_investment\_return\_data

</th>

<th style="text-align:left;">

data\_source\_for\_membership\_data

</th>

<th style="text-align:left;">

data\_source\_for\_plan\_basics

</th>

<th style="text-align:right;">

deductions\_administrative\_expense

</th>

<th style="text-align:right;">

deductions\_cola\_benefit

</th>

<th style="text-align:right;">

deductions\_death\_benefits

</th>

<th style="text-align:right;">

deductions\_depreciation

</th>

<th style="text-align:right;">

deductions\_disability\_benefits

</th>

<th style="text-align:right;">

deductions\_drop\_benefits

</th>

<th style="text-align:right;">

deductions\_lump\_sum\_benefits

</th>

<th style="text-align:right;">

deductions\_other

</th>

<th style="text-align:right;">

deductions\_other\_benefits

</th>

<th style="text-align:right;">

deductions\_refunds\_withdrawals

</th>

<th style="text-align:right;">

deductions\_retirement\_benefits

</th>

<th style="text-align:right;">

deductions\_survivor\_benefits

</th>

<th style="text-align:right;">

deductions\_total

</th>

<th style="text-align:right;">

deductions\_total\_benefit\_payments

</th>

<th style="text-align:right;">

dividend\_income

</th>

<th style="text-align:right;">

drop\_members

</th>

<th style="text-align:right;">

employee\_contributions

</th>

<th style="text-align:right;">

employee\_group\_id

</th>

<th style="text-align:right;">

employer\_annual\_required\_contribution

</th>

<th style="text-align:right;">

employer\_contributions

</th>

<th style="text-align:right;">

employer\_normal\_cost\_amount

</th>

<th style="text-align:right;">

employer\_normal\_cost\_rate

</th>

<th style="text-align:right;">

employer\_projected\_actuarial\_required\_contribution\_amount

</th>

<th style="text-align:right;">

employer\_projected\_actuarial\_required\_contribution\_rate

</th>

<th style="text-align:right;">

employer\_type

</th>

<th style="text-align:right;">

estimated\_1\_yr\_investment\_return

</th>

<th style="text-align:right;">

estimated\_10\_yr\_investment\_return

</th>

<th style="text-align:right;">

estimated\_5\_yr\_investment\_return

</th>

<th style="text-align:right;">

estimated\_average\_benefit\_of\_beneficiaries\_flag

</th>

<th style="text-align:right;">

estimated\_average\_salary\_of\_actives\_flag

</th>

<th style="text-align:right;">

expected\_return\_method

</th>

<th style="text-align:right;">

fiscal\_year

</th>

<th style="text-align:right;">

fiscal\_year\_end\_date

</th>

<th style="text-align:right;">

fiscal\_year\_in\_which\_arc\_adec\_is\_to\_be\_paid

</th>

<th style="text-align:right;">

fiscal\_year\_type

</th>

<th style="text-align:left;">

full\_state\_name

</th>

<th style="text-align:right;">

funded\_ratio\_under\_gasb\_standards

</th>

<th style="text-align:right;">

funding\_method\_code\_number\_1\_for\_gasb\_reporting

</th>

<th style="text-align:right;">

funding\_method\_code\_number\_1\_for\_plan\_reporting

</th>

<th style="text-align:right;">

funding\_method\_code\_number\_2\_for\_gasb\_reporting

</th>

<th style="text-align:right;">

funding\_method\_code\_number\_2\_for\_plan\_reporting

</th>

<th style="text-align:left;">

funding\_method\_for\_plan\_reporting

</th>

<th style="text-align:left;">

funding\_method\_note

</th>

<th style="text-align:right;">

gain\_loss\_base\_number\_1

</th>

<th style="text-align:right;">

gain\_loss\_base\_number\_2

</th>

<th style="text-align:right;">

gain\_loss\_concept

</th>

<th style="text-align:right;">

gain\_loss\_period

</th>

<th style="text-align:right;">

gain\_loss\_recognition

</th>

<th style="text-align:right;">

gain\_loss\_periods\_phased\_in\_for\_asset\_smoothing

</th>

<th style="text-align:left;">

gain\_loss\_values\_to\_be\_included\_in\_smoothed\_asset\_calculation

</th>

<th style="text-align:right;">

gain\_loss\_values\_used\_in\_smoothing

</th>

<th style="text-align:right;">

geometric\_growth\_since\_2001

</th>

<th style="text-align:right;">

geometric\_return\_since\_2001

</th>

<th style="text-align:right;">

include\_judges\_or\_attorneys

</th>

<th style="text-align:right;">

inflation\_rate\_assumption\_for\_gasb\_reporting

</th>

<th style="text-align:right;">

interest\_and\_divident\_net\_income\_total

</th>

<th style="text-align:right;">

interest\_income

</th>

<th style="text-align:right;">

internal\_adjustment\_to\_market\_assets

</th>

<th style="text-align:right;">

international\_income

</th>

<th style="text-align:right;">

investment\_return\_assumption\_for\_gasb\_reporting

</th>

<th style="text-align:right;">

investments\_net

</th>

<th style="text-align:right;">

local\_employers

</th>

<th style="text-align:right;">

long\_term\_investment\_return

</th>

<th style="text-align:right;">

lower\_corridor\_for\_market\_vs\_actuarial\_assets

</th>

<th style="text-align:right;">

market\_assets\_reported\_for\_asset\_smoothing

</th>

<th style="text-align:right;">

market\_assets\_reported\_in\_actuarial\_valuation

</th>

<th style="text-align:right;">

member\_contribution\_amount

</th>

<th style="text-align:right;">

member\_contribution\_rate

</th>

<th style="text-align:right;">

member\_service\_purchase

</th>

<th style="text-align:right;">

net\_assets

</th>

<th style="text-align:right;">

net\_change\_in\_fair\_value\_of\_investments

</th>

<th style="text-align:right;">

net\_change\_in\_fair\_value\_of\_real\_estate\_investments

</th>

<th style="text-align:right;">

net\_flows\_reported\_for\_asset\_smoothing

</th>

<th style="text-align:right;">

net\_investments\_interest\_and\_dividends

</th>

<th style="text-align:right;">

net\_investments\_investment\_expense

</th>

<th style="text-align:right;">

net\_pension\_liability

</th>

<th style="text-align:right;">

net\_position

</th>

<th style="text-align:left;">

no\_actuarial\_valuation

</th>

<th style="text-align:left;">

no\_cafr

</th>

<th style="text-align:right;">

other\_additions

</th>

<th style="text-align:right;">

other\_contributions

</th>

<th style="text-align:right;">

other\_investment\_expense

</th>

<th style="text-align:right;">

other\_investment\_income

</th>

<th style="text-align:right;">

other\_liability

</th>

<th style="text-align:right;">

other\_members

</th>

<th style="text-align:right;">

payroll\_growth\_assumption

</th>

<th style="text-align:right;">

percent\_of\_adec\_paid

</th>

<th style="text-align:right;">

percent\_of\_arc\_paid

</th>

<th style="text-align:right;">

percent\_of\_assets\_invested\_in\_alternatives

</th>

<th style="text-align:right;">

percent\_of\_assets\_invested\_in\_bonds

</th>

<th style="text-align:right;">

percent\_of\_assets\_invested\_in\_cash

</th>

<th style="text-align:right;">

percent\_of\_assets\_invested\_in\_cash\_short\_term\_instruments

</th>

<th style="text-align:right;">

percent\_of\_assets\_invested\_in\_commodities

</th>

<th style="text-align:right;">

percent\_of\_assets\_invested\_in\_equities

</th>

<th style="text-align:right;">

percent\_of\_assets\_invested\_in\_equity\_investments\_total

</th>

<th style="text-align:right;">

percent\_of\_assets\_invested\_in\_fixed\_income

</th>

<th style="text-align:right;">

percent\_of\_assets\_invested\_in\_foreign\_bonds

</th>

<th style="text-align:right;">

percent\_of\_assets\_invested\_in\_hedge\_funds

</th>

<th style="text-align:right;">

percent\_of\_assets\_invested\_in\_international\_equities

</th>

<th style="text-align:right;">

percent\_of\_assets\_invested\_in\_other

</th>

<th style="text-align:right;">

percent\_of\_assets\_invested\_in\_other\_investments

</th>

<th style="text-align:right;">

percent\_of\_assets\_invested\_in\_private\_equity

</th>

<th style="text-align:right;">

percent\_of\_assets\_invested\_in\_real\_estate

</th>

<th style="text-align:right;">

percent\_of\_assets\_invested\_in\_real\_estate\_2

</th>

<th style="text-align:right;">

percent\_of\_assets\_invested\_in\_us\_bonds

</th>

<th style="text-align:right;">

percent\_of\_assets\_invested\_in\_us\_equities

</th>

<th style="text-align:right;">

percent\_of\_employer\_required\_contribution\_paid

</th>

<th style="text-align:right;">

percent\_of\_gain\_loss\_to\_be\_phased\_in\_this\_year

</th>

<th style="text-align:left;">

plan\_full\_name

</th>

<th style="text-align:right;">

plan\_level\_data

</th>

<th style="text-align:left;">

plan\_name

</th>

<th style="text-align:right;">

plan\_type

</th>

<th style="text-align:right;">

ppd\_directory\_listed

</th>

<th style="text-align:right;">

present\_value\_of\_active\_future\_benefits

</th>

<th style="text-align:right;">

present\_value\_of\_future\_employer\_normal\_costs

</th>

<th style="text-align:right;">

present\_value\_of\_future\_member\_contributions

</th>

<th style="text-align:right;">

present\_value\_of\_future\_salaries

</th>

<th style="text-align:right;">

present\_value\_of\_inactive\_non\_vested\_future\_benefits

</th>

<th style="text-align:right;">

present\_value\_of\_inactive\_vested\_future\_benefits

</th>

<th style="text-align:right;">

present\_value\_of\_other\_future\_benefits

</th>

<th style="text-align:right;">

present\_value\_of\_retiree\_future\_benefits

</th>

<th style="text-align:right;">

present\_value\_of\_total\_costs

</th>

<th style="text-align:right;">

private\_equity\_expense

</th>

<th style="text-align:right;">

private\_equity\_income

</th>

<th style="text-align:right;">

projected\_payroll

</th>

<th style="text-align:right;">

public\_plans\_database\_id

</th>

<th style="text-align:right;">

real\_estate\_expense

</th>

<th style="text-align:right;">

real\_estate\_income

</th>

<th style="text-align:right;">

remaining\_amortization\_period

</th>

<th style="text-align:right;">

reported\_investment\_returns

</th>

<th style="text-align:left;">

reporting\_date\_notes

</th>

<th style="text-align:right;">

school\_employees

</th>

<th style="text-align:right;">

school\_employers

</th>

<th style="text-align:left;">

securities\_lending\_fair\_value\_change

</th>

<th style="text-align:left;">

securities\_lending\_fair\_value\_change\_ug

</th>

<th style="text-align:right;">

securities\_lending\_total

</th>

<th style="text-align:right;">

securities\_lending\_total\_net\_expenses

</th>

<th style="text-align:right;">

securities\_lending\_interest

</th>

<th style="text-align:right;">

securities\_lending\_rebates

</th>

<th style="text-align:right;">

securities\_lending\_appreciation\_income

</th>

<th style="text-align:right;">

securities\_management\_lending\_fees

</th>

<th style="text-align:right;">

smoothing\_reset

</th>

<th style="text-align:left;">

social\_security\_coverage\_of\_plan\_members

</th>

<th style="text-align:left;">

source\_for\_actuarial\_liabilities

</th>

<th style="text-align:left;">

source\_for\_asset\_allocation

</th>

<th style="text-align:right;">

source\_indicator

</th>

<th style="text-align:left;">

source\_reference\_for\_funding\_and\_methods

</th>

<th style="text-align:left;">

source\_reference\_for\_gasb\_assumptions

</th>

<th style="text-align:left;">

starting\_year\_for\_long\_term\_investment\_return\_calculation

</th>

<th style="text-align:left;">

state\_abbreviation

</th>

<th style="text-align:right;">

state\_contributions

</th>

<th style="text-align:right;">

state\_employers

</th>

<th style="text-align:right;">

system\_id

</th>

<th style="text-align:right;">

targeted\_percent\_of\_assets\_invested\_in\_cash

</th>

<th style="text-align:right;">

targeted\_percent\_of\_assets\_invested\_in\_commodities

</th>

<th style="text-align:right;">

targeted\_percent\_of\_assets\_invested\_in\_fixed\_income

</th>

<th style="text-align:right;">

targeted\_percent\_of\_assets\_invested\_in\_hedge\_funds

</th>

<th style="text-align:right;">

targeted\_percent\_of\_assets\_invested\_in\_misc\_alternatives

</th>

<th style="text-align:right;">

targeted\_percent\_of\_assets\_invested\_in\_other\_investments

</th>

<th style="text-align:right;">

targeted\_percent\_of\_assets\_invested\_in\_private\_equity

</th>

<th style="text-align:right;">

targeted\_percent\_of\_assets\_invested\_in\_real\_estate

</th>

<th style="text-align:right;">

teacher\_only\_plan

</th>

<th style="text-align:right;">

tier\_id

</th>

<th style="text-align:right;">

total\_additions

</th>

<th style="text-align:right;">

total\_amortization\_period

</th>

<th style="text-align:right;">

total\_amount\_of\_active\_salaries\_payroll

</th>

<th style="text-align:right;">

total\_annual\_benefit\_payments\_in\_year

</th>

<th style="text-align:right;">

total\_benefits\_paid\_to\_disability\_retirees

</th>

<th style="text-align:right;">

total\_benefits\_paid\_to\_service\_retirees

</th>

<th style="text-align:right;">

total\_contributions

</th>

<th style="text-align:right;">

total\_normal\_cost\_amount

</th>

<th style="text-align:right;">

total\_normal\_cost\_rate

</th>

<th style="text-align:right;">

total\_number\_of\_actives

</th>

<th style="text-align:right;">

total\_number\_of\_beneficiaries

</th>

<th style="text-align:left;">

total\_number\_of\_dependent\_survivor\_beneficiaries

</th>

<th style="text-align:left;">

total\_number\_of\_disability\_retirees

</th>

<th style="text-align:right;">

total\_number\_of\_inactive\_non\_vested

</th>

<th style="text-align:right;">

total\_number\_of\_inactive\_vested

</th>

<th style="text-align:right;">

total\_number\_of\_members

</th>

<th style="text-align:right;">

total\_number\_of\_other\_beneficiaries

</th>

<th style="text-align:right;">

total\_number\_of\_service\_retirees

</th>

<th style="text-align:right;">

total\_number\_of\_spousal\_survivor\_beneficiaries

</th>

<th style="text-align:right;">

total\_number\_of\_survivor\_beneficiaries

</th>

<th style="text-align:right;">

total\_pension\_liability

</th>

<th style="text-align:right;">

total\_present\_value\_of\_future\_normal\_costs

</th>

<th style="text-align:right;">

total\_projected\_actuarial\_required\_contribution\_amount

</th>

<th style="text-align:right;">

total\_projected\_actuarial\_required\_contribution\_rate

</th>

<th style="text-align:left;">

type\_of\_employees\_covered

</th>

<th style="text-align:right;">

unfunded\_actuarial\_accrued\_liability\_rate

</th>

<th style="text-align:right;">

unfunded\_actuarial\_accrued\_liability\_under\_gasb\_standards

</th>

<th style="text-align:right;">

unfunded\_liability\_amortization\_period\_for\_gasb\_reporting

</th>

<th style="text-align:right;">

unfunded\_liability\_year\_established

</th>

<th style="text-align:right;">

upper\_corridor\_for\_market\_vs\_actuarial\_assets

</th>

<th style="text-align:right;">

valuation\_id

</th>

<th style="text-align:right;">

wage\_inflation

</th>

<th style="text-align:right;">

was\_employer\_annual\_required\_contribution\_estimated\_by\_crr

</th>

<th style="text-align:right;">

was\_employer\_normal\_cost\_rate\_estimated\_by\_crr

</th>

<th style="text-align:right;">

was\_employer\_projected\_actuarial\_required\_contribution\_rate\_estimated\_by\_crr

</th>

<th style="text-align:right;">

was\_estimated\_member\_contribution\_rate\_estimated\_by\_crr

</th>

<th style="text-align:right;">

was\_funded\_ratio\_estimated\_by\_crr

</th>

<th style="text-align:right;">

was\_total\_normal\_cost\_rate\_estimated\_by\_crr

</th>

<th style="text-align:right;">

were\_actuarial\_assets\_estimated\_by\_crr

</th>

<th style="text-align:right;">

were\_actuarial\_liabilities\_estimated\_by\_crr

</th>

<th style="text-align:right;">

year\_of\_inception

</th>

<th style="text-align:right;">

year\_of\_plan\_closing

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

2001

</td>

<td style="text-align:right;">

790

</td>

<td style="text-align:left;">

Kansas Public Employees’ Retirement System

</td>

<td style="text-align:left;">

Kansas

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:left;">

Pension Plan Database

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-23251.90

</td>

<td style="text-align:right;">

\-1061275.00

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.55

</td>

<td style="text-align:left;">

\-0.0600,0.0320

</td>

<td style="text-align:right;">

\-0.073

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0000000

</td>

<td style="text-align:right;">

0.055

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0000

</td>

<td style="text-align:right;">

0.094

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

11140014

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

9835182

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:left;">

Projected Unit Credit

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

12/31/2000

</td>

<td style="text-align:right;">

36891

</td>

<td style="text-align:right;">

36891

</td>

<td style="text-align:right;">

37256

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

249356.7

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Kansas

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0.072

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0810000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-0.082

</td>

<td style="text-align:right;">

0.154

</td>

<td style="text-align:right;">

\-0.1738519

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

44.17

</td>

<td style="text-align:right;">

72.97

</td>

<td style="text-align:right;">

72.97

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

9.958

</td>

<td style="text-align:right;">

9.958

</td>

<td style="text-align:right;">

32.041

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

10.21

</td>

<td style="text-align:right;">

10721260

</td>

<td style="text-align:left;">

<http://www.kpers.org/active/benefits.html>

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

193384.3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

Multiemployer, cost sharing plan

</td>

<td style="text-align:right;">

4876555

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

page 34

</td>

<td style="text-align:left;">

pg 42- EXHIBIT 12: SUMMARY OF MEMBERSHIP

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

\-6843.434

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-8227.488

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-46456.60

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-43967.62

</td>

<td style="text-align:right;">

\-550674.1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-656169.2

</td>

<td style="text-align:right;">

\-605358.2

</td>

<td style="text-align:right;">

37639.69

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

204142.8

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

249356.7

</td>

<td style="text-align:right;">

193384.3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0000000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0000000

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2001

</td>

<td style="text-align:right;">

37072

</td>

<td style="text-align:right;">

2004

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:left;">

Kansas

</td>

<td style="text-align:right;">

0.88

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0092700

</td>

<td style="text-align:right;">

\-0.0730000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.035

</td>

<td style="text-align:right;">

281676.9

</td>

<td style="text-align:right;">

201483.1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.08

</td>

<td style="text-align:right;">

\-798126.8

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.00

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

9664667

</td>

<td style="text-align:right;">

\-1061275.00

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

239122.8

</td>

<td style="text-align:right;">

\-23251.90

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

175.815

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

556.969

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.04

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

0.776

</td>

<td style="text-align:right;">

0.0489

</td>

<td style="text-align:right;">

0.3308

</td>

<td style="text-align:right;">

0.0100

</td>

<td style="text-align:right;">

0.0313

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.5208

</td>

<td style="text-align:right;">

0.5400

</td>

<td style="text-align:right;">

0.3300

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.1271

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0500

</td>

<td style="text-align:right;">

0.0700

</td>

<td style="text-align:right;">

0.0682

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.3937

</td>

<td style="text-align:right;">

0.776

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Kansas Public Employees Retirement System

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

Kansas PERS

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4319879

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

39

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

41997.15

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

4723.223

</td>

<td style="text-align:right;">

\-58226.88

</td>

<td style="text-align:right;">

62950.11

</td>

<td style="text-align:right;">

\-56202.76

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-2024.120

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Plan members covered by Social Security

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

2001 KPERS p 44

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

2001 KPERS AV p. 71, 77

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

KS

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

35

</td>

<td style="text-align:right;">

0.01

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.32

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.05

</td>

<td style="text-align:right;">

0.07

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-400423.87

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5116384

</td>

<td style="text-align:right;">

558772.4

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

558772.4

</td>

<td style="text-align:right;">

397527.1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0000000

</td>

<td style="text-align:right;">

145910

</td>

<td style="text-align:right;">

56115

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

38056

</td>

<td style="text-align:right;">

240081

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

56115

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0000000

</td>

<td style="text-align:left;">

Plan covers state and local employees

</td>

<td style="text-align:right;">

0.0000000

</td>

<td style="text-align:right;">

1304832

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

39

</td>

<td style="text-align:right;">

0.04

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1962

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

2002

</td>

<td style="text-align:right;">

790

</td>

<td style="text-align:left;">

Kansas Public Employees’ Retirement System

</td>

<td style="text-align:left;">

Kansas

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:left;">

Pension Plan Database

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-19758.14

</td>

<td style="text-align:right;">

\-676384.75

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.52

</td>

<td style="text-align:left;">

\-0.0360,0.0100

</td>

<td style="text-align:right;">

\-0.047

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0000000

</td>

<td style="text-align:right;">

0.001

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0000

</td>

<td style="text-align:right;">

0.054

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

11743052

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

9962918

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:left;">

Projected Unit Credit

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

12/31/2001

</td>

<td style="text-align:right;">

37256

</td>

<td style="text-align:right;">

37256

</td>

<td style="text-align:right;">

37621

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

260483.0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Kansas

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Level Percent Closed

</td>

<td style="text-align:right;">

0.028

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0680909

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-0.082

</td>

<td style="text-align:right;">

0.077

</td>

<td style="text-align:right;">

\-0.1266154

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Expected value plus 1/3 of difference between market and expected

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

44.39

</td>

<td style="text-align:right;">

72.37

</td>

<td style="text-align:right;">

72.37

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

10.425

</td>

<td style="text-align:right;">

10.425

</td>

<td style="text-align:right;">

32.984

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

10.37

</td>

<td style="text-align:right;">

9664667

</td>

<td style="text-align:left;">

<http://www.kpers.org/active/benefits.html>

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

221473.7

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

Multiemployer, cost sharing plan

</td>

<td style="text-align:right;">

5116384

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

pg 26 t5 pg 31 tb 6

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

page 43

</td>

<td style="text-align:left;">

pg 42- EXHIBIT 12: SUMMARY OF MEMBERSHIP

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

\-6776.044

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-8694.809

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-47625.76

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-39066.94

</td>

<td style="text-align:right;">

\-627704.1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-729867.0

</td>

<td style="text-align:right;">

\-684024.6

</td>

<td style="text-align:right;">

24416.40

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

209624.0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

260483.0

</td>

<td style="text-align:right;">

221473.7

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0446991

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.1275558

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2002

</td>

<td style="text-align:right;">

37437

</td>

<td style="text-align:right;">

2005

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:left;">

Kansas

</td>

<td style="text-align:right;">

0.85

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0088343

</td>

<td style="text-align:right;">

\-0.0600899

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.035

</td>

<td style="text-align:right;">

229084.9

</td>

<td style="text-align:right;">

159209.2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.08

</td>

<td style="text-align:right;">

\-463747.0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.04

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

8902288

</td>

<td style="text-align:right;">

\-676384.74

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

183625.6

</td>

<td style="text-align:right;">

\-19758.14

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

137.633

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

667.029

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.04

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

0.797

</td>

<td style="text-align:right;">

0.0519

</td>

<td style="text-align:right;">

0.3759

</td>

<td style="text-align:right;">

0.0200

</td>

<td style="text-align:right;">

0.0376

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.4604

</td>

<td style="text-align:right;">

0.5200

</td>

<td style="text-align:right;">

0.3300

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.1559

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0500

</td>

<td style="text-align:right;">

0.0800

</td>

<td style="text-align:right;">

0.0742

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.3045

</td>

<td style="text-align:right;">

0.797

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Kansas Public Employees Retirement System

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

Kansas PERS

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4615164

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5511763

</td>

<td style="text-align:right;">

39

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

44792.32

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

3310.983

</td>

<td style="text-align:right;">

\-29999.83

</td>

<td style="text-align:right;">

33310.81

</td>

<td style="text-align:right;">

\-28577.30

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-1422.527

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Plan members covered by Social Security

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

2002 KPERS p 46

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

2002 KPERS AV p. 10, 74

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

KS

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

35

</td>

<td style="text-align:right;">

0.01

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.34

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.05

</td>

<td style="text-align:right;">

0.08

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-32511.58

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4865903

</td>

<td style="text-align:right;">

600463.0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

600463.0

</td>

<td style="text-align:right;">

431097.7

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0846991

</td>

<td style="text-align:right;">

147294

</td>

<td style="text-align:right;">

57597

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

40404

</td>

<td style="text-align:right;">

245295

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

57597

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.1675558

</td>

<td style="text-align:left;">

Plan covers state and local employees

</td>

<td style="text-align:right;">

0.0828567

</td>

<td style="text-align:right;">

1780134

</td>

<td style="text-align:right;">

31

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

39

</td>

<td style="text-align:right;">

0.04

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1962

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

2003

</td>

<td style="text-align:right;">

790

</td>

<td style="text-align:left;">

Kansas Public Employees’ Retirement System

</td>

<td style="text-align:left;">

Kansas

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:left;">

Pension Plan Database

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-16675.17

</td>

<td style="text-align:right;">

85223.48

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.52

</td>

<td style="text-align:left;">

0.0490,0.0210

</td>

<td style="text-align:right;">

0.040

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-0.0266667

</td>

<td style="text-align:right;">

\-0.028

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0000

</td>

<td style="text-align:right;">

0.031

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

12613599

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

9784862

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:left;">

Projected Unit Credit

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

12/31/2002

</td>

<td style="text-align:right;">

37621

</td>

<td style="text-align:right;">

37621

</td>

<td style="text-align:right;">

37986

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

282329.8

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Kansas

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Level Percent Closed

</td>

<td style="text-align:right;">

0.019

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.1556977

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-0.142

</td>

<td style="text-align:right;">

0.064

</td>

<td style="text-align:right;">

\-0.0206698

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Expected value plus 1/3 of difference between market and expected

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

44.71

</td>

<td style="text-align:right;">

72.23

</td>

<td style="text-align:right;">

72.23

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

10.752

</td>

<td style="text-align:right;">

10.752

</td>

<td style="text-align:right;">

32.944

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

10.60

</td>

<td style="text-align:right;">

8902288

</td>

<td style="text-align:left;">

<http://www.kpers.org/active/benefits.html>

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

231464.3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

Multiemployer, cost sharing plan

</td>

<td style="text-align:right;">

4865903

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

pg 27 tb 5 pg32 tb6

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

page 43

</td>

<td style="text-align:left;">

pg 24 SUMMARY OF PRINCIPAL RESULTS ALL SYSTEMS COMBINED

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

\-7215.024

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-7826.064

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-53829.24

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-39608.95

</td>

<td style="text-align:right;">

\-645716.1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-754195.3

</td>

<td style="text-align:right;">

\-707371.4

</td>

<td style="text-align:right;">

76508.36

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

224746.4

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

282329.8

</td>

<td style="text-align:right;">

231464.3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0446770

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.1273342

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2003

</td>

<td style="text-align:right;">

37802

</td>

<td style="text-align:right;">

2006

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:left;">

Kansas

</td>

<td style="text-align:right;">

0.78

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0091877

</td>

<td style="text-align:right;">

\-0.0278454

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.035

</td>

<td style="text-align:right;">

253694.5

</td>

<td style="text-align:right;">

145411.3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.08

</td>

<td style="text-align:right;">

326046.6

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.04

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

8930442

</td>

<td style="text-align:right;">

85223.48

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

221919.6

</td>

<td style="text-align:right;">

\-16675.17

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

82.257

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

557.611

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.04

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

0.789

</td>

<td style="text-align:right;">

0.0515

</td>

<td style="text-align:right;">

0.3468

</td>

<td style="text-align:right;">

0.0030

</td>

<td style="text-align:right;">

0.0404

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.4949

</td>

<td style="text-align:right;">

0.5300

</td>

<td style="text-align:right;">

0.3440

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.1727

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0530

</td>

<td style="text-align:right;">

0.0700

</td>

<td style="text-align:right;">

0.0664

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.3222

</td>

<td style="text-align:right;">

0.789

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Kansas Public Employees Retirement System

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

Kansas PERS

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5056236

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5878684

</td>

<td style="text-align:right;">

39

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

31217.26

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

3803.824

</td>

<td style="text-align:right;">

\-22075.12

</td>

<td style="text-align:right;">

25878.94

</td>

<td style="text-align:right;">

\-20861.10

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-1214.021

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Plan members covered by Social Security

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

2003 KPERS p 48

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

2003 KPERS AV p. 42, 83

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

KS

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

35

</td>

<td style="text-align:right;">

0.01

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.34

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.05

</td>

<td style="text-align:right;">

0.08

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

782349.67

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4978132

</td>

<td style="text-align:right;">

635712.4

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

635712.4

</td>

<td style="text-align:right;">

456210.8

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0846770

</td>

<td style="text-align:right;">

148145

</td>

<td style="text-align:right;">

59124

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

41315

</td>

<td style="text-align:right;">

248584

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

59124

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.1673342

</td>

<td style="text-align:left;">

Plan covers state and local employees

</td>

<td style="text-align:right;">

0.0826572

</td>

<td style="text-align:right;">

2828736

</td>

<td style="text-align:right;">

30

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

39

</td>

<td style="text-align:right;">

0.04

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1962

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

2004

</td>

<td style="text-align:right;">

790

</td>

<td style="text-align:left;">

Kansas Public Employees’ Retirement System

</td>

<td style="text-align:left;">

Kansas

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:left;">

Pension Plan Database

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-18718.60

</td>

<td style="text-align:right;">

1087128.88

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.52

</td>

<td style="text-align:left;">

0.1520,0.0320

</td>

<td style="text-align:right;">

0.154

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0490000

</td>

<td style="text-align:right;">

0.046

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0000

</td>

<td style="text-align:right;">

0.038

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

14439546

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

10853462

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

Entry Age Normal

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

12/31/2003

</td>

<td style="text-align:right;">

37986

</td>

<td style="text-align:right;">

37986

</td>

<td style="text-align:right;">

38352

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

338880.0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Kansas

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Level Percent Closed

</td>

<td style="text-align:right;">

0.011

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0382674

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.187

</td>

<td style="text-align:right;">

0.159

</td>

<td style="text-align:right;">

0.2251792

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Difference between actual return and return and expected return on
return on market value calculated early and recognized evenly over
five-year period

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

44.98

</td>

<td style="text-align:right;">

72.13

</td>

<td style="text-align:right;">

72.13

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

11.103

</td>

<td style="text-align:right;">

11.103

</td>

<td style="text-align:right;">

33.854

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

10.85

</td>

<td style="text-align:right;">

8930442

</td>

<td style="text-align:left;">

<http://www.kpers.org/active/benefits.html>

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

714353.2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

Multiemployer, cost sharing plan

</td>

<td style="text-align:right;">

4978132

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

pg 40 tb 7 normal cost rate pg 44 tb 10

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

page 42

</td>

<td style="text-align:left;">

pg 24 SUMMARY OF PRINCIPAL RESULTS ALL SYSTEMS COMBINED

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

\-7231.295

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-8685.182

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-50396.39

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-41179.47

</td>

<td style="text-align:right;">

\-676918.6

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-784411.0

</td>

<td style="text-align:right;">

\-736000.2

</td>

<td style="text-align:right;">

91477.15

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

230350.0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

338880.0

</td>

<td style="text-align:right;">

714353.2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0423748

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.1041968

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2004

</td>

<td style="text-align:right;">

38168

</td>

<td style="text-align:right;">

2007

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:left;">

Kansas

</td>

<td style="text-align:right;">

0.75

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0106026

</td>

<td style="text-align:right;">

0.0147357

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.035

</td>

<td style="text-align:right;">

263561.4

</td>

<td style="text-align:right;">

132004.0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.08

</td>

<td style="text-align:right;">

1336225.9

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.04

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

10427143

</td>

<td style="text-align:right;">

1087128.88

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

223481.2

</td>

<td style="text-align:right;">

\-18718.60

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

182.113

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

565.492

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.04

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

0.694

</td>

<td style="text-align:right;">

0.0500

</td>

<td style="text-align:right;">

0.3422

</td>

<td style="text-align:right;">

0.0030

</td>

<td style="text-align:right;">

0.0170

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.5251

</td>

<td style="text-align:right;">

0.5300

</td>

<td style="text-align:right;">

0.3440

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.1986

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0530

</td>

<td style="text-align:right;">

0.0700

</td>

<td style="text-align:right;">

0.0657

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.3265

</td>

<td style="text-align:right;">

0.694

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Kansas Public Employees Retirement System

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

Kansas PERS

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5497654

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3419149

</td>

<td style="text-align:right;">

39

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

39514.69

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

4254.285

</td>

<td style="text-align:right;">

\-18765.82

</td>

<td style="text-align:right;">

23020.10

</td>

<td style="text-align:right;">

\-17697.45

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-1068.372

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Plan members covered by Social Security

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

2004 KPERS p 48

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

2004 KPERS AV p. 46, 91

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

KS

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

35

</td>

<td style="text-align:right;">

0.01

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.34

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.05

</td>

<td style="text-align:right;">

0.08

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2281111.20

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5102016

</td>

<td style="text-align:right;">

678675.1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

678675.1

</td>

<td style="text-align:right;">

944703.2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0823748

</td>

<td style="text-align:right;">

147751

</td>

<td style="text-align:right;">

61125

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

41269

</td>

<td style="text-align:right;">

250145

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

61125

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.1441968

</td>

<td style="text-align:left;">

Plan covers state and local employees

</td>

<td style="text-align:right;">

0.0618220

</td>

<td style="text-align:right;">

3586084

</td>

<td style="text-align:right;">

29

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

39

</td>

<td style="text-align:right;">

0.04

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1962

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

2005

</td>

<td style="text-align:right;">

790

</td>

<td style="text-align:left;">

Kansas Public Employees’ Retirement System

</td>

<td style="text-align:left;">

Kansas

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:left;">

Pension Plan Database

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-22070.01

</td>

<td style="text-align:right;">

932881.69

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.57

</td>

<td style="text-align:left;">

0.1080,0.0250

</td>

<td style="text-align:right;">

0.121

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.1050000

</td>

<td style="text-align:right;">

0.101

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0390

</td>

<td style="text-align:right;">

0.039

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

15714092

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

10971427

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

Entry Age Normal

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

12/31/2004

</td>

<td style="text-align:right;">

38352

</td>

<td style="text-align:right;">

38352

</td>

<td style="text-align:right;">

38717

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

381791.1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Kansas

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Level Percent Closed

</td>

<td style="text-align:right;">

0.021

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0000000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.128

</td>

<td style="text-align:right;">

0.261

</td>

<td style="text-align:right;">

0.1117012

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Difference between actual return and return and expected return on
return on market value calculated early and recognized evenly over
five-year period

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

45.04

</td>

<td style="text-align:right;">

72.09

</td>

<td style="text-align:right;">

72.09

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

11.436

</td>

<td style="text-align:right;">

11.436

</td>

<td style="text-align:right;">

34.661

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

10.86

</td>

<td style="text-align:right;">

10427143

</td>

<td style="text-align:left;">

<http://www.kpers.org/active/benefits.html>

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

293952.4

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

Multiemployer, cost sharing plan

</td>

<td style="text-align:right;">

5102016

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

pg 46 tb 7 normal cost rate pg 50 tb 10

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

page 56

</td>

<td style="text-align:left;">

pg 24 SUMMARY OF PRINCIPAL RESULTS ALL SYSTEMS COMBINED

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

\-7340.147

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-7849.884

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-53703.11

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-46773.93

</td>

<td style="text-align:right;">

\-737563.3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-853230.3

</td>

<td style="text-align:right;">

\-799116.3

</td>

<td style="text-align:right;">

130167.48

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

233226.0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

381791.1

</td>

<td style="text-align:right;">

293952.4

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0443546

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.1240939

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2005

</td>

<td style="text-align:right;">

38533

</td>

<td style="text-align:right;">

2008

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:left;">

Kansas

</td>

<td style="text-align:right;">

0.70

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0118855

</td>

<td style="text-align:right;">

0.0351505

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.035

</td>

<td style="text-align:right;">

307207.1

</td>

<td style="text-align:right;">

132806.1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.08

</td>

<td style="text-align:right;">

1223096.1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.04

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

11324365

</td>

<td style="text-align:right;">

932881.71

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

262973.6

</td>

<td style="text-align:right;">

\-22070.01

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

178.105

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

412.211

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.04

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

0.686

</td>

<td style="text-align:right;">

0.0446

</td>

<td style="text-align:right;">

0.3046

</td>

<td style="text-align:right;">

0.0457

</td>

<td style="text-align:right;">

0.0457

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.5322

</td>

<td style="text-align:right;">

0.5322

</td>

<td style="text-align:right;">

0.3046

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.2262

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0446

</td>

<td style="text-align:right;">

0.0729

</td>

<td style="text-align:right;">

0.0729

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.3060

</td>

<td style="text-align:right;">

0.686

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Kansas Public Employees Retirement System

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

Kansas PERS

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5886986

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4729568

</td>

<td style="text-align:right;">

39

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

43821.31

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

5077.334

</td>

<td style="text-align:right;">

\-47981.81

</td>

<td style="text-align:right;">

53059.14

</td>

<td style="text-align:right;">

\-46714.33

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-1267.475

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Plan members covered by Social Security

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

2005 KPERS p 57

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

2005 KPERS AV p. 46, 97

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

KS

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

35

</td>

<td style="text-align:right;">

0.01

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.29

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.05

</td>

<td style="text-align:right;">

0.08

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1750452.68

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5270350

</td>

<td style="text-align:right;">

724441.8

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

724441.8

</td>

<td style="text-align:right;">

527178.5

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0843546

</td>

<td style="text-align:right;">

149073

</td>

<td style="text-align:right;">

63348

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

41426

</td>

<td style="text-align:right;">

253847

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

63348

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.1640939

</td>

<td style="text-align:left;">

Plan covers state and local employees

</td>

<td style="text-align:right;">

0.0797393

</td>

<td style="text-align:right;">

4742666

</td>

<td style="text-align:right;">

28

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

39

</td>

<td style="text-align:right;">

0.04

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1962

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

2006

</td>

<td style="text-align:right;">

790

</td>

<td style="text-align:left;">

Kansas Public Employees’ Retirement System

</td>

<td style="text-align:left;">

Kansas

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:left;">

Pension Plan Database

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-27204.51

</td>

<td style="text-align:right;">

1046279.06

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.57

</td>

<td style="text-align:left;">

0.1040,0.0430

</td>

<td style="text-align:right;">

0.123

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.1326667

</td>

<td style="text-align:right;">

0.133

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0782

</td>

<td style="text-align:right;">

0.076

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

16491762

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

11339293

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

Entry Age Normal

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

12/31/2005

</td>

<td style="text-align:right;">

38717

</td>

<td style="text-align:right;">

38717

</td>

<td style="text-align:right;">

39082

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

471424.0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Kansas

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Level Percent Closed

</td>

<td style="text-align:right;">

0.040

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0000000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.270

</td>

<td style="text-align:right;">

0.223

</td>

<td style="text-align:right;">

0.0000000

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Difference between actual return and return and expected return on
return on market value calculated early and recognized evenly over
five-year period

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

45.14

</td>

<td style="text-align:right;">

72.01

</td>

<td style="text-align:right;">

72.01

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

11.777

</td>

<td style="text-align:right;">

11.777

</td>

<td style="text-align:right;">

36.246

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

10.84

</td>

<td style="text-align:right;">

11324365

</td>

<td style="text-align:left;">

<http://www.kpers.org/active/benefits.html>

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

352031.6

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

Multiemployer, cost sharing plan

</td>

<td style="text-align:right;">

5270351

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

pg 46 tb 7 normal cost rate pg 50 tb 10

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

page 52

</td>

<td style="text-align:left;">

pg 25 SUMMARY OF PRINCIPAL RESULTS ALL SYSTEMS COMBINED

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

\-7718.879

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-8810.923

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-54957.96

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-46826.18

</td>

<td style="text-align:right;">

\-805978.7

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-924292.7

</td>

<td style="text-align:right;">

\-869747.6

</td>

<td style="text-align:right;">

113162.35

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

246203.4

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

471424.0

</td>

<td style="text-align:right;">

352031.5

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0443677

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.1242258

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

2006

</td>

<td style="text-align:right;">

38898

</td>

<td style="text-align:right;">

2009

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:left;">

Kansas

</td>

<td style="text-align:right;">

0.69

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0133474

</td>

<td style="text-align:right;">

0.0492996

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.035

</td>

<td style="text-align:right;">

330767.7

</td>

<td style="text-align:right;">

165466.5

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.08

</td>

<td style="text-align:right;">

1354407.8

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.04

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

12352890

</td>

<td style="text-align:right;">

1046279.08

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

278628.9

</td>

<td style="text-align:right;">

\-27204.51

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

175.539

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

303.028

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.04

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

0.634

</td>

<td style="text-align:right;">

0.0425

</td>

<td style="text-align:right;">

0.2942

</td>

<td style="text-align:right;">

0.0417

</td>

<td style="text-align:right;">

0.0417

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.5495

</td>

<td style="text-align:right;">

0.5495

</td>

<td style="text-align:right;">

0.2942

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.2473

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0425

</td>

<td style="text-align:right;">

0.0721

</td>

<td style="text-align:right;">

0.0721

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.3022

</td>

<td style="text-align:right;">

0.634

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Kansas Public Employees Retirement System

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

Kansas PERS

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

6294460

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

4886164

</td>

<td style="text-align:right;">

39

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

51835.81

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

4565.486

</td>

<td style="text-align:right;">

\-83345.67

</td>

<td style="text-align:right;">

87911.15

</td>

<td style="text-align:right;">

\-82182.20

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

\-1163.472

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Plan members covered by Social Security

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

2006 KPERS p 53

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

2006 KPERS AV p. 48, 111

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

KS

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

35

</td>

<td style="text-align:right;">

0.01

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.29

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.05

</td>

<td style="text-align:right;">

0.08

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1952818.23

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

5599194

</td>

<td style="text-align:right;">

774531.2

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

774531.2

</td>

<td style="text-align:right;">

598234.9

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.0843677

</td>

<td style="text-align:right;">

151449

</td>

<td style="text-align:right;">

65765

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

40858

</td>

<td style="text-align:right;">

258072

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

65765

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0.1642258

</td>

<td style="text-align:left;">

Plan covers state and local employees

</td>

<td style="text-align:right;">

0.0798580

</td>

<td style="text-align:right;">

5152469

</td>

<td style="text-align:right;">

27

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

39

</td>

<td style="text-align:right;">

0.04

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1962

</td>

<td style="text-align:right;">

0

</td>

</tr>

</tbody>

</table>

### `loadData`

3.  `loadData`: loads the data for a specified plan from an Excel file.
    `loadData` has one argument:

`loadData(file_name)`

  - `file_name`: A string enclosed in quotation marks containing a file
    name with path of a pension plan Excel data
    file.

<!-- end list -->

    data_from_file <- loadData('data/NorthCarolina_PensionDatabase_TSERS.xlsx')

### `selectedData()`

4.  `selectedData()`: selects the only the variables used in historical
    analyses. `selectedData` has eleven arguments, with the first,
    `wide_data`, being required:

`selectedData(wide_data, .date_var =
"actuarial_valuation_date_for_gasb_assumptions", .aal_var =
.actuarial_accrued_liabilities_under_gasb_standards", .mva_var =
"beginning_market_assets_net", .ava_var =
"actuarial_assets_under_gasb_standards",.tpl_var =
"total_pension_liability", .adec_var =
"employer_annual_required_contribution", .er_cont_var =
"employer_contributions", .ee_cont_var = "employee_contributions",
.payroll_var = "covered_payroll", .arr_var =
"investment_return_assumption_for_gasb_reporting")`

  - `wide_data`: a datasource in wide format
  - `.date_var` column name for valuation date. Default: ‘Actuarial
    Valuation Date For GASB Assumptions’
  - `.mva_var`: column name for Market Value of Assets. Default:
    ‘beginning\_market\_assets\_net’
  - `.aal_var` column name AAL. Default: ‘Actuarial Accrued Liabilities
    Under GASB Standards’
  - `.ava_var` column name for Actuarial Assets. Default: ‘Actuarial
    Assets under GASB standards’
  - `.tpl_var` column name for Total Pension Liability. Default:
    “total\_pension\_liability”,
  - `.adec_var` column name for ADEC. Default: ‘Employer Annual Required
    Contribution’
  - `.er_cont_var` column name for employer contributions. Default:
    ‘Employer Contributions’
  - `.ee_cont_var` column name for employee contributions. Default:
    ‘Employee Contributions’
  - `.payroll_var` column name for payroll. Default: ‘Covered Payroll’
  - `.arr_var` column name for the Assumed Rate of Return. Default:
    ‘investment\_return\_assumption\_for\_gasb\_reporting’

Back to the Kansas Public Employees’ example. That is a lot of
variables. The `selectedData()` function selects only a handful of
needed variables:

``` r
df <- selectedData(kpers_data)
df %>% 
  head() %>%
  kable() %>%
  kable_styling(full_width = FALSE, position = "left")
```

<table class="table" style="width: auto !important; ">

<thead>

<tr>

<th style="text-align:right;">

year

</th>

<th style="text-align:left;">

valuation\_date

</th>

<th style="text-align:right;">

market\_value\_assets

</th>

<th style="text-align:right;">

actuarial\_assets

</th>

<th style="text-align:right;">

aal

</th>

<th style="text-align:right;">

tpl

</th>

<th style="text-align:right;">

adec

</th>

<th style="text-align:right;">

er\_cont

</th>

<th style="text-align:right;">

ee\_cont

</th>

<th style="text-align:right;">

payroll

</th>

<th style="text-align:right;">

assumed\_rate\_of\_return

</th>

<th style="text-align:right;">

uaal

</th>

<th style="text-align:right;">

funded\_ratio

</th>

<th style="text-align:right;">

adec\_contribution\_rates

</th>

<th style="text-align:right;">

actual\_contribution\_rates

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:right;">

2000

</td>

<td style="text-align:left;">

2000-12-31

</td>

<td style="text-align:right;">

10721260

</td>

<td style="text-align:right;">

9835182

</td>

<td style="text-align:right;">

11140014

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

249356.7

</td>

<td style="text-align:right;">

193384.3

</td>

<td style="text-align:right;">

204142.8

</td>

<td style="text-align:right;">

4876555

</td>

<td style="text-align:right;">

0.08

</td>

<td style="text-align:right;">

1304832

</td>

<td style="text-align:right;">

0.8828698

</td>

<td style="text-align:right;">

0.0511338

</td>

<td style="text-align:right;">

0.0396559

</td>

</tr>

<tr>

<td style="text-align:right;">

2001

</td>

<td style="text-align:left;">

2001-12-31

</td>

<td style="text-align:right;">

9664667

</td>

<td style="text-align:right;">

9962918

</td>

<td style="text-align:right;">

11743052

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

260483.0

</td>

<td style="text-align:right;">

221473.7

</td>

<td style="text-align:right;">

209624.0

</td>

<td style="text-align:right;">

5116384

</td>

<td style="text-align:right;">

0.08

</td>

<td style="text-align:right;">

1780134

</td>

<td style="text-align:right;">

0.8484096

</td>

<td style="text-align:right;">

0.0509115

</td>

<td style="text-align:right;">

0.0432872

</td>

</tr>

<tr>

<td style="text-align:right;">

2002

</td>

<td style="text-align:left;">

2002-12-31

</td>

<td style="text-align:right;">

8902288

</td>

<td style="text-align:right;">

9784862

</td>

<td style="text-align:right;">

12613599

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

282329.8

</td>

<td style="text-align:right;">

231464.3

</td>

<td style="text-align:right;">

224746.4

</td>

<td style="text-align:right;">

4865903

</td>

<td style="text-align:right;">

0.08

</td>

<td style="text-align:right;">

2828737

</td>

<td style="text-align:right;">

0.7757391

</td>

<td style="text-align:right;">

0.0580221

</td>

<td style="text-align:right;">

0.0475686

</td>

</tr>

<tr>

<td style="text-align:right;">

2003

</td>

<td style="text-align:left;">

2003-12-31

</td>

<td style="text-align:right;">

8930442

</td>

<td style="text-align:right;">

10853462

</td>

<td style="text-align:right;">

14439546

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

338880.0

</td>

<td style="text-align:right;">

714353.2

</td>

<td style="text-align:right;">

230350.0

</td>

<td style="text-align:right;">

4978132

</td>

<td style="text-align:right;">

0.08

</td>

<td style="text-align:right;">

3586084

</td>

<td style="text-align:right;">

0.7516484

</td>

<td style="text-align:right;">

0.0680737

</td>

<td style="text-align:right;">

0.1434982

</td>

</tr>

<tr>

<td style="text-align:right;">

2004

</td>

<td style="text-align:left;">

2004-12-31

</td>

<td style="text-align:right;">

10427143

</td>

<td style="text-align:right;">

10971427

</td>

<td style="text-align:right;">

15714092

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

381791.1

</td>

<td style="text-align:right;">

293952.4

</td>

<td style="text-align:right;">

233226.0

</td>

<td style="text-align:right;">

5102016

</td>

<td style="text-align:right;">

0.08

</td>

<td style="text-align:right;">

4742665

</td>

<td style="text-align:right;">

0.6981903

</td>

<td style="text-align:right;">

0.0748314

</td>

<td style="text-align:right;">

0.0576150

</td>

</tr>

<tr>

<td style="text-align:right;">

2005

</td>

<td style="text-align:left;">

2005-12-31

</td>

<td style="text-align:right;">

11324365

</td>

<td style="text-align:right;">

11339293

</td>

<td style="text-align:right;">

16491762

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

471424.0

</td>

<td style="text-align:right;">

352031.5

</td>

<td style="text-align:right;">

246203.4

</td>

<td style="text-align:right;">

5270351

</td>

<td style="text-align:right;">

0.08

</td>

<td style="text-align:right;">

5152469

</td>

<td style="text-align:right;">

0.6875732

</td>

<td style="text-align:right;">

0.0894483

</td>

<td style="text-align:right;">

0.0667947

</td>

</tr>

</tbody>

</table>

### `reasonStyle()`

5.  `reasonStyle()`: has no arguments and is added to the ggplot chain
    after you have created a plot. What it does is generally makes text
    size, font and colour, axis lines, axis text and many other standard
    chart components into Reason style.

The function is pretty basic and does not change or adapt based on the
type of chart you are making, so in some cases you will need to make
additional `theme` arguments in your ggplot chain if you want to make
any additions or changes to the style, for example to add or remove
gridlines etc. Also note that colours for lines in the case of a line
chart or bars for a bar chart, do not come out of the box from the
`reasonStyle` function, but need to be explicitly set in your other
standard `ggplot` chart functions.

Example of how it is used in a standard workflow:

    line <- ggplot2(line_df, aes(x = year, y = lifeExp)) +
    geom_line(colour = "#007f7f", size = 1) +
    geom_hline(yintercept = 0, size = 1, colour="#333333") +
    reasonStyle()

### `glPlot()`

6.  `glPlot()`: creates the ‘Gain/Loss’ plot using a CSV file as an
    input. glPlot has two arguments:

`glPlot(filename, ylab_unit)`

  - `filename`: a csv (comma separated value) file containing columns of
    gain loss category names with one row of values.
  - `ylab_unit`: a string contained within quotation marks containing th
    y-axis label unit. The default value is “Billions”

Example of how it is used in a standard workflow:

    filename <- "data/GainLoss_data.csv"
    glPlot(filename)

### `linePlot()`

7.  `linePlot()`: creates a plot comparing two variables, such as ADEC
    vs. Actual contributions. `linePlot()` has six arguments, with
    `data` being required:

`linePlot(data, .var1, .var2, labelY, label1, label2)`

  - `data` a dataframe produced by the selectedData function or in the
    same format.
  - `.var1` The name of the first variable to plat, default is
    adec\_contribution\_rates.
  - `.var2` The name of the second variable to plot, default if
    actual\_contribution\_rates.
  - `labelY` A label for the Y-axis.
  - `label1` A label for the first variable.
  - `label2` A label for the second variable.

<!-- end list -->

``` r
linePlot(df)
```

<img src="man/figures/README-contributions-1.png" width="100%" />

### `debtPlot()`

8.  `debtPlot()`: creates the “History of Volatile Solvency” or
    “Mountain of Debt” chart. `debtPlot` takes one argument:

`debtPlot(data)`

  - `data`: a dataframe produced by the `selectedData()` function or in
    the same format containing year, uaal, funded ratio columns.

<img src="man/figures/README-plot1-1.png" width="100%" />

### `savePlot()`

9.  `savePlot()`: adds a source and save ggplot chart. `savePlot` takes
    five arguments: `savePlot(plot = myplot, source = "The source for my
    data", save_filepath =
    "filename_that_my_plot_should_be_saved_to.png", width_pixels = 648,
    height_pixels = 384.48)`

<!-- end list -->

  - `plot`: The variable name of the plot you have created that you want
    to format and save
  - `source`: The text you want to come after the text ‘Source:’ in the
    bottom left hand side of your side
  - `save_filepath`: Exact filepath that you want the plot to be saved
    to
  - `width_pixels`: Width in pixels that you want to save your chart to
    - defaults to 648
  - `height_pixels`: Height in pixels that you want to save your chart
    to - defaults to
    384.48

<!-- end list -->

    savePlot(debt_plot, source = "Source: KPERS", save_filepath = "output/test.png")

The BBC has created a wonderful data journalism cookbook for R graphics
located here: <https://bbc.github.io/rcookbook/>
