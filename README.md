
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
interest. Let’s use Texas Teacher Retirement System as an example. Let’s
first see what plans in Texas are available with the word "teacher’ in
the
name:

``` r
TX <- pl %>% filter(state == 'Texas', str_detect(tolower(display_name), pattern = "teacher"))
TX %>% 
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

1877

</td>

<td style="text-align:left;">

Texas Teacher Retirement System

</td>

<td style="text-align:left;">

Texas

</td>

</tr>

</tbody>

</table>

The full plan name we are interested in is there listed as “Texas
Teacher Retirement System”. We can pull the data for it now:

``` r
ttrs_data <- pullData(pl, plan_name = "Texas Teacher Retirement System")
ttrs_data %>% 
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

plan\_id

</th>

<th style="text-align:left;">

display\_name

</th>

<th style="text-align:left;">

state

</th>

<th style="text-align:right;">

x1\_year\_investment\_return\_percentage

</th>

<th style="text-align:right;">

x10\_year\_investment\_return\_percentage

</th>

<th style="text-align:right;">

x12\_year\_investment\_return\_percentage

</th>

<th style="text-align:right;">

x15\_year\_investment\_return\_percentage

</th>

<th style="text-align:right;">

x2\_year\_investment\_return\_percentage

</th>

<th style="text-align:right;">

x20\_year\_investment\_return\_percentage

</th>

<th style="text-align:right;">

x25\_year\_investment\_return\_percentage

</th>

<th style="text-align:right;">

x3\_year\_investment\_return\_percentage

</th>

<th style="text-align:right;">

x30\_year\_investment\_return\_percentage

</th>

<th style="text-align:right;">

x4\_year\_investment\_return\_percentage

</th>

<th style="text-align:right;">

x5\_year\_investment\_return\_percentage

</th>

<th style="text-align:right;">

x7\_year\_investment\_return\_percentage

</th>

<th style="text-align:right;">

x8\_year\_investment\_return\_percentage

</th>

<th style="text-align:right;">

actuarial\_assets\_reported\_for\_asset\_smoothing

</th>

<th style="text-align:right;">

actuarial\_cost\_method\_code\_names

</th>

<th style="text-align:right;">

actuarial\_cost\_method\_code\_names\_for\_gasb

</th>

<th style="text-align:left;">

actuarial\_cost\_method\_in\_gasb\_reporting

</th>

<th style="text-align:left;">

actuarial\_cost\_method\_in\_valaution

</th>

<th style="text-align:left;">

actuarial\_cost\_method\_notes

</th>

<th style="text-align:right;">

actuarial\_funded\_ratio\_percentage

</th>

<th style="text-align:right;">

actuarial\_liabilities\_entry\_age\_normal\_dollar

</th>

<th style="text-align:right;">

actuarial\_liabilities\_projected\_union\_credit\_dollar

</th>

<th style="text-align:right;">

actuarial\_report\_calendar\_year

</th>

<th style="text-align:left;">

actuarial\_valuation\_date\_for\_actuarial\_costs

</th>

<th style="text-align:right;">

actuarial\_valuation\_date\_for\_gasb\_schedules

</th>

<th style="text-align:right;">

actuarial\_valuation\_report\_date

</th>

<th style="text-align:right;">

actuarial\_value\_of\_assets\_dollar

</th>

<th style="text-align:right;">

actuarial\_value\_of\_assets\_gasb\_dollar

</th>

<th style="text-align:right;">

actuarially\_accrued\_liabilities\_dollar

</th>

<th style="text-align:right;">

actuarially\_determined\_contribution\_dollar

</th>

<th style="text-align:right;">

actuarially\_determined\_contribution\_percentage\_of\_payroll

</th>

<th style="text-align:right;">

actuarially\_required\_contribution\_dollar

</th>

<th style="text-align:right;">

actuarially\_required\_contribution\_paid\_percentage

</th>

<th style="text-align:right;">

adjustment\_to\_market\_value\_of\_assets\_dollar

</th>

<th style="text-align:right;">

administering\_government\_type

</th>

<th style="text-align:left;">

administrating\_jurisdiction

</th>

<th style="text-align:right;">

administrative\_expense\_dollar

</th>

<th style="text-align:right;">

administrative\_expense\_in\_normal\_cost\_dollar

</th>

<th style="text-align:right;">

alternative\_expense\_dollar

</th>

<th style="text-align:right;">

alternative\_investments\_percentage

</th>

<th style="text-align:right;">

alternatives\_income\_dollar

</th>

<th style="text-align:left;">

amortizaton\_method

</th>

<th style="text-align:right;">

amounts\_transmitted\_to\_federal\_social\_security\_system\_dollar

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

basis\_of\_membership\_and\_participation

</th>

<th style="text-align:right;">

benefit\_payments\_dollar

</th>

<th style="text-align:right;">

benefits\_paid\_to\_disability\_retirees\_dollar

</th>

<th style="text-align:right;">

benefits\_paid\_to\_service\_retirees\_dollar

</th>

<th style="text-align:left;">

benefits\_website

</th>

<th style="text-align:right;">

blended\_discount\_rate

</th>

<th style="text-align:right;">

bonds\_corporate\_book\_value\_dollar

</th>

<th style="text-align:right;">

bonds\_corporate\_other\_book\_value\_dollar

</th>

<th style="text-align:right;">

bonds\_corporate\_other\_dollar

</th>

<th style="text-align:right;">

bonds\_federally\_sponsored\_investments\_dollar

</th>

<th style="text-align:right;">

cafr\_calendar\_year

</th>

<th style="text-align:right;">

cash\_and\_short\_term\_investments\_dollar

</th>

<th style="text-align:right;">

cash\_and\_short\_term\_investments\_percentage

</th>

<th style="text-align:right;">

cash\_on\_hand\_and\_demand\_deposits\_dollar

</th>

<th style="text-align:right;">

census\_coverage\_type

</th>

<th style="text-align:right;">

census\_retirement\_system\_code

</th>

<th style="text-align:right;">

closed\_plan

</th>

<th style="text-align:right;">

cola\_benefits\_paid\_dollar

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

cost\_sharing

</th>

<th style="text-align:left;">

cost\_structure

</th>

<th style="text-align:right;">

covered\_payroll\_dollar

</th>

<th style="text-align:right;">

covered\_payroll\_gasb\_dollar

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

death\_benefits\_paid\_dollar

</th>

<th style="text-align:right;">

depreciation\_expense\_dollar

</th>

<th style="text-align:right;">

disability\_benefits\_paid\_dollar

</th>

<th style="text-align:right;">

dividends\_income\_dollar

</th>

<th style="text-align:right;">

do\_employees\_contribute

</th>

<th style="text-align:right;">

domestic\_fixed\_income\_percentage

</th>

<th style="text-align:right;">

domestic\_investments\_percentage

</th>

<th style="text-align:right;">

drop\_benefits\_paid\_dollar

</th>

<th style="text-align:right;">

drop\_members

</th>

<th style="text-align:right;">

employee\_contribution\_dollar

</th>

<th style="text-align:right;">

employee\_group\_id

</th>

<th style="text-align:right;">

employee\_normal\_cost\_dollar

</th>

<th style="text-align:right;">

employee\_normal\_cost\_percentage

</th>

<th style="text-align:right;">

employee\_normal\_cost\_percentage\_estimated\_categorical

</th>

<th style="text-align:right;">

employees\_receiving\_lump\_sum\_payments

</th>

<th style="text-align:right;">

employer\_contribution\_other\_dollar

</th>

<th style="text-align:right;">

employer\_contribution\_regular\_dollar

</th>

<th style="text-align:right;">

employer\_contribution\_state\_dollar

</th>

<th style="text-align:right;">

employer\_normal\_cost\_dollar

</th>

<th style="text-align:right;">

employer\_normal\_cost\_percentage

</th>

<th style="text-align:right;">

employer\_normal\_cost\_percentage\_estimated\_categorical

</th>

<th style="text-align:right;">

employer\_regular\_contribution\_dollar

</th>

<th style="text-align:right;">

employer\_state\_contribution\_dollar

</th>

<th style="text-align:right;">

employer\_type

</th>

<th style="text-align:right;">

employers\_projected\_actuarial\_required\_contribution\_dollar

</th>

<th style="text-align:right;">

employers\_projected\_actuarial\_required\_contribution\_percentage\_of\_payroll

</th>

<th style="text-align:right;">

estimated\_actuarial\_assets\_indicator

</th>

<th style="text-align:right;">

estimated\_actuarial\_funded\_ratio\_indicator

</th>

<th style="text-align:right;">

estimated\_actuarial\_liabilities\_indicator

</th>

<th style="text-align:right;">

estimated\_employers\_projected\_actuarial\_required\_contribution\_categorical

</th>

<th style="text-align:right;">

expected\_return\_method

</th>

<th style="text-align:right;">

fair\_value\_change\_investments

</th>

<th style="text-align:right;">

federal\_agency\_securities\_investments\_dollar

</th>

<th style="text-align:right;">

federal\_government\_securities\_investments\_dollar

</th>

<th style="text-align:right;">

federal\_treasury\_securities\_investments\_dollar

</th>

<th style="text-align:right;">

federally\_sponsored\_agnecy\_securities\_investments\_dollar

</th>

<th style="text-align:right;">

fiscal\_year

</th>

<th style="text-align:right;">

fiscal\_year\_end\_date

</th>

<th style="text-align:right;">

fiscal\_year\_of\_contribution

</th>

<th style="text-align:right;">

fiscal\_year\_type

</th>

<th style="text-align:right;">

foreign\_and\_international\_securities\_investments\_1997\_2001\_dollar

</th>

<th style="text-align:right;">

foreign\_and\_international\_securities\_investments\_2001\_present\_dollar

</th>

<th style="text-align:right;">

former\_active\_members\_retired\_on\_account\_of\_age\_or\_service

</th>

<th style="text-align:right;">

former\_active\_members\_retired\_on\_account\_of\_disability

</th>

<th style="text-align:left;">

full\_state\_name

</th>

<th style="text-align:right;">

funding\_method\_code\_1\_for\_gasb\_reporting

</th>

<th style="text-align:right;">

funding\_method\_code\_1\_for\_plan\_reporting

</th>

<th style="text-align:right;">

funding\_method\_code\_2\_for\_gasb\_reporting

</th>

<th style="text-align:right;">

funding\_method\_code\_2\_for\_plan\_reporting

</th>

<th style="text-align:left;">

funding\_method\_for\_plan\_reporting

</th>

<th style="text-align:left;">

funding\_method\_note

</th>

<th style="text-align:right;">

gain\_from\_investments\_dollar

</th>

<th style="text-align:right;">

gain\_loss\_base\_1

</th>

<th style="text-align:right;">

gain\_loss\_base\_2

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

geometric\_growth\_percentage

</th>

<th style="text-align:right;">

geometric\_return\_percentage

</th>

<th style="text-align:right;">

gross\_or\_net\_investment\_returns\_categorical

</th>

<th style="text-align:right;">

inactive\_members

</th>

<th style="text-align:right;">

include\_judges\_or\_attorneys

</th>

<th style="text-align:right;">

inflation\_rate\_assumption\_for\_gasb\_reporting

</th>

<th style="text-align:right;">

interest\_and\_dividends\_income\_dollar

</th>

<th style="text-align:right;">

interest\_income\_dollar

</th>

<th style="text-align:right;">

international\_fixed\_income\_percentage

</th>

<th style="text-align:right;">

international\_income\_dollar

</th>

<th style="text-align:right;">

international\_investments\_percentage

</th>

<th style="text-align:right;">

investment\_expenses\_dollar

</th>

<th style="text-align:right;">

investment\_return\_assumption\_for\_gasb\_reporting

</th>

<th style="text-align:right;">

investments\_held\_in\_trust\_by\_other\_agencies\_dollar

</th>

<th style="text-align:right;">

local\_employee\_contribution\_dollar

</th>

<th style="text-align:right;">

local\_employers

</th>

<th style="text-align:right;">

local\_government\_active\_members

</th>

<th style="text-align:right;">

local\_government\_contribution\_dollar

</th>

<th style="text-align:right;">

long\_term\_investment\_return\_percentage

</th>

<th style="text-align:left;">

long\_term\_investment\_return\_starting\_year

</th>

<th style="text-align:right;">

loss\_from\_investments\_dollar

</th>

<th style="text-align:right;">

lower\_corridor\_for\_market\_vs\_actuarial\_assets

</th>

<th style="text-align:right;">

lump\_sum\_benefits\_paid\_dollar

</th>

<th style="text-align:right;">

management\_fees\_for\_securities\_lending\_dollar

</th>

<th style="text-align:right;">

market\_assets\_reported\_for\_asset\_smoothing

</th>

<th style="text-align:right;">

market\_funded\_ratio\_percentage

</th>

<th style="text-align:right;">

market\_value\_of\_assets\_dollar

</th>

<th style="text-align:right;">

market\_value\_of\_assets\_net\_of\_fees\_dollar

</th>

<th style="text-align:right;">

members\_covered\_by\_social\_security

</th>

<th style="text-align:right;">

monthly\_lump\_sum\_payments\_to\_members\_dollar

</th>

<th style="text-align:right;">

monthly\_lump\_sum\_payments\_to\_survivors\_dollar

</th>

<th style="text-align:right;">

monthly\_payments\_to\_disabled\_dollar

</th>

<th style="text-align:right;">

monthly\_payments\_to\_retirees\_dollar

</th>

<th style="text-align:right;">

monthly\_payments\_to\_survivors\_dollar

</th>

<th style="text-align:right;">

mortgage\_investments\_dollar

</th>

<th style="text-align:right;">

net\_expenses\_dollar

</th>

<th style="text-align:right;">

net\_flows\_reported\_for\_asset\_smoothing

</th>

<th style="text-align:right;">

net\_pension\_liability\_dollar

</th>

<th style="text-align:right;">

net\_position\_dollar

</th>

<th style="text-align:left;">

no\_actuarial\_valuation

</th>

<th style="text-align:left;">

no\_cafr

</th>

<th style="text-align:right;">

number\_of\_survivors

</th>

<th style="text-align:right;">

number\_of\_years\_remaining\_on\_amortization\_schedule

</th>

<th style="text-align:right;">

optional\_benefits\_available

</th>

<th style="text-align:right;">

other\_actuarially\_accured\_liabilities\_dollar

</th>

<th style="text-align:right;">

other\_additions\_dollar

</th>

<th style="text-align:right;">

other\_benefits\_paid\_dollar

</th>

<th style="text-align:right;">

other\_contribution\_dollar

</th>

<th style="text-align:right;">

other\_deductions\_dollar

</th>

<th style="text-align:right;">

other\_employee\_contributions\_dollar

</th>

<th style="text-align:right;">

other\_investments\_dollar

</th>

<th style="text-align:right;">

other\_investments\_income\_dollar

</th>

<th style="text-align:right;">

other\_investments\_percentage

</th>

<th style="text-align:right;">

other\_members

</th>

<th style="text-align:right;">

other\_payments\_dollar

</th>

<th style="text-align:right;">

other\_receipts\_paid\_dollar

</th>

<th style="text-align:right;">

other\_securities\_investments\_dollar

</th>

<th style="text-align:right;">

payroll\_growth\_assumption

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

present\_value\_of\_future\_benefits\_for\_active\_members\_dollar

</th>

<th style="text-align:left;">

present\_value\_of\_future\_benefits\_for\_inactive\_non\_vested\_members\_dollar

</th>

<th style="text-align:right;">

present\_value\_of\_future\_benefits\_for\_inactive\_vested\_members\_dollar

</th>

<th style="text-align:right;">

present\_value\_of\_future\_benefits\_for\_other\_members\_dollar

</th>

<th style="text-align:right;">

present\_value\_of\_future\_benefits\_for\_retired\_members\_dollar

</th>

<th style="text-align:right;">

present\_value\_of\_future\_benefits\_for\_total\_members\_dollar

</th>

<th style="text-align:right;">

present\_value\_of\_future\_normal\_costs\_employee\_dollar

</th>

<th style="text-align:right;">

present\_value\_of\_future\_normal\_costs\_employer\_dollar

</th>

<th style="text-align:right;">

present\_value\_of\_future\_normal\_costs\_total\_dollar

</th>

<th style="text-align:right;">

present\_value\_of\_future\_services\_dollar

</th>

<th style="text-align:right;">

private\_equity\_investments\_dollar

</th>

<th style="text-align:right;">

private\_equity\_investments\_income\_dollar

</th>

<th style="text-align:right;">

projected\_payroll\_dollar

</th>

<th style="text-align:right;">

public\_plans\_database\_id

</th>

<th style="text-align:right;">

real\_estate\_income\_dollar

</th>

<th style="text-align:right;">

real\_estate\_investments\_dollar

</th>

<th style="text-align:right;">

real\_estate\_investments\_percentage

</th>

<th style="text-align:right;">

receipts\_for\_transmittal\_to\_federal\_social\_security\_system\_dollar

</th>

<th style="text-align:right;">

refunds\_dollar

</th>

<th style="text-align:right;">

remaining\_amortization\_period

</th>

<th style="text-align:right;">

rentals\_from\_state\_government\_dollar

</th>

<th style="text-align:left;">

reporting\_date\_notes

</th>

<th style="text-align:right;">

retirement\_benefits\_paid\_dollar

</th>

<th style="text-align:right;">

school\_employees

</th>

<th style="text-align:right;">

school\_employers

</th>

<th style="text-align:right;">

securities\_lending\_dollar

</th>

<th style="text-align:right;">

securities\_lending\_income\_dollar

</th>

<th style="text-align:right;">

securities\_lending\_rebates\_dollar

</th>

<th style="text-align:right;">

service\_purchase\_dollar

</th>

<th style="text-align:right;">

short\_term\_investments\_dollar

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

<th style="text-align:left;">

source\_reference\_for\_funding\_and\_methods

</th>

<th style="text-align:left;">

source\_reference\_for\_gasb\_assumptions

</th>

<th style="text-align:left;">

state\_abbreviation

</th>

<th style="text-align:right;">

state\_and\_local\_government\_securitites\_investments\_dollar

</th>

<th style="text-align:right;">

state\_contribution\_for\_employee\_dollar

</th>

<th style="text-align:right;">

state\_contribution\_to\_own\_system\_on\_behalf\_of\_employees\_dollar

</th>

<th style="text-align:right;">

state\_employee\_contribution\_dollar

</th>

<th style="text-align:right;">

state\_employers

</th>

<th style="text-align:right;">

state\_government\_active\_members

</th>

<th style="text-align:right;">

stocks\_corporate\_book\_value\_dollar

</th>

<th style="text-align:right;">

stocks\_corporate\_dollar

</th>

<th style="text-align:right;">

survivior\_benefits\_paid\_dollar

</th>

<th style="text-align:right;">

survivors\_receiving\_lump\_sum\_payments

</th>

<th style="text-align:right;">

system\_id

</th>

<th style="text-align:right;">

teacher\_only\_plan

</th>

<th style="text-align:right;">

tier\_id

</th>

<th style="text-align:right;">

time\_or\_savings\_deposits\_dollar

</th>

<th style="text-align:right;">

total\_active\_members

</th>

<th style="text-align:right;">

total\_additions\_dollar

</th>

<th style="text-align:right;">

total\_amortization\_payment\_percentage

</th>

<th style="text-align:right;">

total\_amortization\_period

</th>

<th style="text-align:right;">

total\_amount\_of\_active\_salaries\_payroll\_in\_dollars

</th>

<th style="text-align:right;">

total\_benefits\_paid\_dollar

</th>

<th style="text-align:right;">

total\_cash\_and\_securities\_investments\_dollar

</th>

<th style="text-align:right;">

total\_contribution\_dollar

</th>

<th style="text-align:right;">

total\_corporate\_bonds\_investments\_dollar

</th>

<th style="text-align:right;">

total\_earnings\_on\_investments\_dollar

</th>

<th style="text-align:right;">

total\_equities\_investments\_percentage

</th>

<th style="text-align:right;">

total\_fixed\_income\_percentage

</th>

<th style="text-align:right;">

total\_normal\_cost\_dollar

</th>

<th style="text-align:right;">

total\_normal\_cost\_percentage

</th>

<th style="text-align:right;">

total\_normal\_cost\_percentage\_estimated\_categorical

</th>

<th style="text-align:right;">

total\_number\_of\_beneficiaries

</th>

<th style="text-align:left;">

total\_number\_of\_dependent\_survivor\_beneficiaries

</th>

<th style="text-align:right;">

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

total\_other\_investments\_dollar

</th>

<th style="text-align:right;">

total\_other\_securities\_investments\_dollar

</th>

<th style="text-align:right;">

total\_pension\_liability\_dollar

</th>

<th style="text-align:right;">

total\_projected\_actuarial\_required\_contribution\_dollar

</th>

<th style="text-align:right;">

total\_projected\_actuarial\_required\_contribution\_percentage\_of\_payroll

</th>

<th style="text-align:left;">

type\_of\_employees\_covered

</th>

<th style="text-align:right;">

unfunded\_actuarially\_accrued\_liabilities\_dollar

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

vesting\_period

</th>

<th style="text-align:right;">

wage\_inflation

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

1957

</td>

<td style="text-align:right;">

1877

</td>

<td style="text-align:left;">

Texas Teacher Retirement System

</td>

<td style="text-align:left;">

Texas

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

8325000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

1398000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

17072000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

129694000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

4214000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

134431

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

7418000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

1959

</td>

<td style="text-align:right;">

1877

</td>

<td style="text-align:left;">

Texas Teacher Retirement System

</td>

<td style="text-align:left;">

Texas

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

13137000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

4559000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

33142000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

141656000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

4803000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

11739000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

1960

</td>

<td style="text-align:right;">

1877

</td>

<td style="text-align:left;">

Texas Teacher Retirement System

</td>

<td style="text-align:left;">

Texas

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

15214000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

1918000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

31700000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

159656000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

6442000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

14624000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

1961

</td>

<td style="text-align:right;">

1877

</td>

<td style="text-align:left;">

Texas Teacher Retirement System

</td>

<td style="text-align:left;">

Texas

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

16924000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

5126000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

38000000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

159469000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

6752000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

22001000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

1962

</td>

<td style="text-align:right;">

1877

</td>

<td style="text-align:left;">

Texas Teacher Retirement System

</td>

<td style="text-align:left;">

Texas

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

18927000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

7645000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

2429000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

188956000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

7456000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

176284

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

19592000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

1963

</td>

<td style="text-align:right;">

1877

</td>

<td style="text-align:left;">

Texas Teacher Retirement System

</td>

<td style="text-align:left;">

Texas

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

21698000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

823000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

86243000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

281956000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

8509000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

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

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

23098000

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

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
    analyses. `selectedData` has one argument, `wide_data`, that is
    required:

`selectedData(wide_data)`

  - `wide_data`: a datasource in wide format

Back to the Kansas Public Employees’ example. That is a lot of
variables. The `selectedData()` function selects only a handful of
needed variables:

``` r
df <- selectedData(ttrs_data)
df %>% 
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

<th style="text-align:left;">

plan\_name

</th>

<th style="text-align:left;">

state

</th>

<th style="text-align:right;">

return\_1yr

</th>

<th style="text-align:left;">

actuarial\_cost\_method\_in\_gasb\_reporting

</th>

<th style="text-align:right;">

funded\_ratio

</th>

<th style="text-align:right;">

actuarial\_valuation\_date\_for\_gasb\_schedules

</th>

<th style="text-align:right;">

actuarial\_valuation\_report\_date

</th>

<th style="text-align:right;">

ava

</th>

<th style="text-align:right;">

mva

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

adec\_paid\_pct

</th>

<th style="text-align:right;">

admin\_exp

</th>

<th style="text-align:left;">

amortizaton\_method

</th>

<th style="text-align:left;">

asset\_valuation\_method\_for\_gasb\_reporting

</th>

<th style="text-align:right;">

benefit\_payments

</th>

<th style="text-align:left;">

cost\_structure

</th>

<th style="text-align:right;">

payroll

</th>

<th style="text-align:right;">

ee\_contribution

</th>

<th style="text-align:right;">

ee\_nc\_pct

</th>

<th style="text-align:right;">

er\_contribution

</th>

<th style="text-align:right;">

er\_nc\_pct

</th>

<th style="text-align:right;">

er\_state\_contribution

</th>

<th style="text-align:right;">

er\_proj\_adec\_pct

</th>

<th style="text-align:right;">

fy

</th>

<th style="text-align:right;">

fy\_contribution

</th>

<th style="text-align:right;">

inflation\_assum

</th>

<th style="text-align:right;">

arr

</th>

<th style="text-align:right;">

number\_of\_years\_remaining\_on\_amortization\_schedule

</th>

<th style="text-align:right;">

payroll\_growth\_assumption

</th>

<th style="text-align:right;">

total\_amortization\_payment\_pct

</th>

<th style="text-align:right;">

total\_contribution

</th>

<th style="text-align:right;">

total\_nc\_pct

</th>

<th style="text-align:right;">

total\_number\_of\_members

</th>

<th style="text-align:right;">

total\_proj\_adec\_pct

</th>

<th style="text-align:left;">

type\_of\_employees\_covered

</th>

<th style="text-align:right;">

unfunded\_actuarially\_accrued\_liabilities\_dollar

</th>

<th style="text-align:right;">

wage\_inflation

</th>

<th style="text-align:left;">

valuation\_date

</th>

<th style="text-align:right;">

uaal

</th>

<th style="text-align:right;">

funded\_ratio\_calc

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

<td style="text-align:left;">

2001

</td>

<td style="text-align:left;">

Texas Teacher Retirement System

</td>

<td style="text-align:left;">

Texas

</td>

<td style="text-align:right;">

\-0.050

</td>

<td style="text-align:left;">

Entry Age Normal

</td>

<td style="text-align:right;">

1.025

</td>

<td style="text-align:right;">

37134

</td>

<td style="text-align:right;">

37134

</td>

<td style="text-align:right;">

86352000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

84217000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1279039985

</td>

<td style="text-align:right;">

1.00

</td>

<td style="text-align:right;">

\-20795.13

</td>

<td style="text-align:left;">

Level Percent Open

</td>

<td style="text-align:left;">

5-year smoothed market

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Multiple employer, cost sharing plan

</td>

<td style="text-align:right;">

23365000

</td>

<td style="text-align:right;">

1364689

</td>

<td style="text-align:right;">

0.064

</td>

<td style="text-align:right;">

136247.9

</td>

<td style="text-align:right;">

0.0628

</td>

<td style="text-align:right;">

965202000

</td>

<td style="text-align:right;">

0.0600

</td>

<td style="text-align:right;">

2001

</td>

<td style="text-align:right;">

2002

</td>

<td style="text-align:right;">

0.03

</td>

<td style="text-align:right;">

0.08

</td>

<td style="text-align:right;">

100

</td>

<td style="text-align:right;">

0.00

</td>

<td style="text-align:right;">

\-0.0028

</td>

<td style="text-align:right;">

2643729

</td>

<td style="text-align:right;">

0.1268

</td>

<td style="text-align:right;">

994204

</td>

<td style="text-align:right;">

0.1240

</td>

<td style="text-align:left;">

Plan covers teachers

</td>

<td style="text-align:right;">

\-2135000

</td>

<td style="text-align:right;">

0.0000

</td>

<td style="text-align:left;">

2001-08-31

</td>

<td style="text-align:right;">

\-2135000

</td>

<td style="text-align:right;">

1.0253512

</td>

<td style="text-align:right;">

54.74171

</td>

<td style="text-align:right;">

0.0058313

</td>

</tr>

<tr>

<td style="text-align:left;">

2002

</td>

<td style="text-align:left;">

Texas Teacher Retirement System

</td>

<td style="text-align:left;">

Texas

</td>

<td style="text-align:right;">

\-0.064

</td>

<td style="text-align:left;">

Entry Age Normal

</td>

<td style="text-align:right;">

0.963

</td>

<td style="text-align:right;">

37499

</td>

<td style="text-align:right;">

37499

</td>

<td style="text-align:right;">

86035000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

89322000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1291087160

</td>

<td style="text-align:right;">

1.05

</td>

<td style="text-align:right;">

\-24597.36

</td>

<td style="text-align:left;">

Level Percent Open

</td>

<td style="text-align:left;">

5-year smoothed market

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Multiple employer, cost sharing plan

</td>

<td style="text-align:right;">

24818000

</td>

<td style="text-align:right;">

1450312

</td>

<td style="text-align:right;">

0.064

</td>

<td style="text-align:right;">

157781.5

</td>

<td style="text-align:right;">

0.0627

</td>

<td style="text-align:right;">

1201258000

</td>

<td style="text-align:right;">

0.0715

</td>

<td style="text-align:right;">

2002

</td>

<td style="text-align:right;">

2003

</td>

<td style="text-align:right;">

0.03

</td>

<td style="text-align:right;">

0.08

</td>

<td style="text-align:right;">

100

</td>

<td style="text-align:right;">

0.00

</td>

<td style="text-align:right;">

0.0088

</td>

<td style="text-align:right;">

2809351

</td>

<td style="text-align:right;">

0.1267

</td>

<td style="text-align:right;">

985918

</td>

<td style="text-align:right;">

0.1355

</td>

<td style="text-align:left;">

Plan covers teachers

</td>

<td style="text-align:right;">

3287000

</td>

<td style="text-align:right;">

0.0000

</td>

<td style="text-align:left;">

2002-08-31

</td>

<td style="text-align:right;">

3287000

</td>

<td style="text-align:right;">

0.9632006

</td>

<td style="text-align:right;">

52.02221

</td>

<td style="text-align:right;">

0.0063575

</td>

</tr>

<tr>

<td style="text-align:left;">

2003

</td>

<td style="text-align:left;">

Texas Teacher Retirement System

</td>

<td style="text-align:left;">

Texas

</td>

<td style="text-align:right;">

0.047

</td>

<td style="text-align:left;">

Entry Age Normal

</td>

<td style="text-align:right;">

0.945

</td>

<td style="text-align:right;">

37864

</td>

<td style="text-align:right;">

37864

</td>

<td style="text-align:right;">

89033000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

94263000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1694080994

</td>

<td style="text-align:right;">

0.84

</td>

<td style="text-align:right;">

\-23428.16

</td>

<td style="text-align:left;">

Level Percent Open

</td>

<td style="text-align:left;">

5-year smoothed market

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Multiple employer, cost sharing plan

</td>

<td style="text-align:right;">

25767000

</td>

<td style="text-align:right;">

1516802

</td>

<td style="text-align:right;">

0.064

</td>

<td style="text-align:right;">

182536.2

</td>

<td style="text-align:right;">

0.0606

</td>

<td style="text-align:right;">

1239070000

</td>

<td style="text-align:right;">

0.0739

</td>

<td style="text-align:right;">

2003

</td>

<td style="text-align:right;">

2004

</td>

<td style="text-align:right;">

0.03

</td>

<td style="text-align:right;">

0.08

</td>

<td style="text-align:right;">

100

</td>

<td style="text-align:right;">

0.03

</td>

<td style="text-align:right;">

0.0133

</td>

<td style="text-align:right;">

2938408

</td>

<td style="text-align:right;">

0.1246

</td>

<td style="text-align:right;">

1020013

</td>

<td style="text-align:right;">

0.1379

</td>

<td style="text-align:left;">

Plan covers teachers

</td>

<td style="text-align:right;">

5230000

</td>

<td style="text-align:right;">

0.0400

</td>

<td style="text-align:left;">

2003-08-31

</td>

<td style="text-align:right;">

5230000

</td>

<td style="text-align:right;">

0.9445169

</td>

<td style="text-align:right;">

65.74615

</td>

<td style="text-align:right;">

0.0070841

</td>

</tr>

<tr>

<td style="text-align:left;">

2004

</td>

<td style="text-align:left;">

Texas Teacher Retirement System

</td>

<td style="text-align:left;">

Texas

</td>

<td style="text-align:right;">

0.157

</td>

<td style="text-align:left;">

Entry Age Normal

</td>

<td style="text-align:right;">

0.918

</td>

<td style="text-align:right;">

38230

</td>

<td style="text-align:right;">

38230

</td>

<td style="text-align:right;">

88784000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

96737000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1766437660

</td>

<td style="text-align:right;">

0.81

</td>

<td style="text-align:right;">

\-24841.30

</td>

<td style="text-align:left;">

Level Percent Open

</td>

<td style="text-align:left;">

5-year smoothed market

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Multiple employer, cost sharing plan

</td>

<td style="text-align:right;">

25485000

</td>

<td style="text-align:right;">

1530277

</td>

<td style="text-align:right;">

0.064

</td>

<td style="text-align:right;">

192395.7

</td>

<td style="text-align:right;">

0.0532

</td>

<td style="text-align:right;">

1239070000

</td>

<td style="text-align:right;">

0.0731

</td>

<td style="text-align:right;">

2004

</td>

<td style="text-align:right;">

2005

</td>

<td style="text-align:right;">

0.03

</td>

<td style="text-align:right;">

0.08

</td>

<td style="text-align:right;">

100

</td>

<td style="text-align:right;">

0.03

</td>

<td style="text-align:right;">

0.0199

</td>

<td style="text-align:right;">

2964462

</td>

<td style="text-align:right;">

0.1172

</td>

<td style="text-align:right;">

1013189

</td>

<td style="text-align:right;">

0.1371

</td>

<td style="text-align:left;">

Plan covers teachers

</td>

<td style="text-align:right;">

7953000

</td>

<td style="text-align:right;">

0.0425

</td>

<td style="text-align:left;">

2004-08-31

</td>

<td style="text-align:right;">

7953000

</td>

<td style="text-align:right;">

0.9177874

</td>

<td style="text-align:right;">

69.31284

</td>

<td style="text-align:right;">

0.0075494

</td>

</tr>

<tr>

<td style="text-align:left;">

2005

</td>

<td style="text-align:left;">

Texas Teacher Retirement System

</td>

<td style="text-align:left;">

Texas

</td>

<td style="text-align:right;">

0.095

</td>

<td style="text-align:left;">

Entry Age Normal

</td>

<td style="text-align:right;">

0.871

</td>

<td style="text-align:right;">

38595

</td>

<td style="text-align:right;">

38595

</td>

<td style="text-align:right;">

89299000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

102495000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1801708659

</td>

<td style="text-align:right;">

0.82

</td>

<td style="text-align:right;">

\-25114.72

</td>

<td style="text-align:left;">

Level Percent Open

</td>

<td style="text-align:left;">

5-year smoothed market

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Multiple employer, cost sharing plan

</td>

<td style="text-align:right;">

25957000

</td>

<td style="text-align:right;">

1578339

</td>

<td style="text-align:right;">

0.064

</td>

<td style="text-align:right;">

221158.9

</td>

<td style="text-align:right;">

0.0400

</td>

<td style="text-align:right;">

1241789000

</td>

<td style="text-align:right;">

0.0719

</td>

<td style="text-align:right;">

2005

</td>

<td style="text-align:right;">

2006

</td>

<td style="text-align:right;">

0.03

</td>

<td style="text-align:right;">

0.08

</td>

<td style="text-align:right;">

30

</td>

<td style="text-align:right;">

0.03

</td>

<td style="text-align:right;">

0.0319

</td>

<td style="text-align:right;">

3057170

</td>

<td style="text-align:right;">

0.1040

</td>

<td style="text-align:right;">

1009077

</td>

<td style="text-align:right;">

0.1359

</td>

<td style="text-align:left;">

Plan covers teachers

</td>

<td style="text-align:right;">

13196000

</td>

<td style="text-align:right;">

0.0425

</td>

<td style="text-align:left;">

2005-08-31

</td>

<td style="text-align:right;">

13196000

</td>

<td style="text-align:right;">

0.8712523

</td>

<td style="text-align:right;">

69.41128

</td>

<td style="text-align:right;">

0.0085202

</td>

</tr>

<tr>

<td style="text-align:left;">

2006

</td>

<td style="text-align:left;">

Texas Teacher Retirement System

</td>

<td style="text-align:left;">

Texas

</td>

<td style="text-align:right;">

0.104

</td>

<td style="text-align:left;">

Entry Age Normal

</td>

<td style="text-align:right;">

0.873

</td>

<td style="text-align:right;">

38960

</td>

<td style="text-align:right;">

38960

</td>

<td style="text-align:right;">

94218000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

107911000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

1912840426

</td>

<td style="text-align:right;">

0.83

</td>

<td style="text-align:right;">

\-26444.40

</td>

<td style="text-align:left;">

Level Percent Open

</td>

<td style="text-align:left;">

5-year smoothed market

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

Multiple employer, cost sharing plan

</td>

<td style="text-align:right;">

28397000

</td>

<td style="text-align:right;">

1700415

</td>

<td style="text-align:right;">

0.064

</td>

<td style="text-align:right;">

267399.6

</td>

<td style="text-align:right;">

0.0400

</td>

<td style="text-align:right;">

1257672000

</td>

<td style="text-align:right;">

0.0702

</td>

<td style="text-align:right;">

2006

</td>

<td style="text-align:right;">

2007

</td>

<td style="text-align:right;">

0.03

</td>

<td style="text-align:right;">

0.08

</td>

<td style="text-align:right;">

30

</td>

<td style="text-align:right;">

0.03

</td>

<td style="text-align:right;">

0.0302

</td>

<td style="text-align:right;">

3299917

</td>

<td style="text-align:right;">

0.1040

</td>

<td style="text-align:right;">

1067126

</td>

<td style="text-align:right;">

0.1342

</td>

<td style="text-align:left;">

Plan covers teachers

</td>

<td style="text-align:right;">

13694000

</td>

<td style="text-align:right;">

0.0425

</td>

<td style="text-align:left;">

2006-08-31

</td>

<td style="text-align:right;">

13693000

</td>

<td style="text-align:right;">

0.8731084

</td>

<td style="text-align:right;">

67.36065

</td>

<td style="text-align:right;">

0.0094165

</td>

</tr>

</tbody>

</table>

### `glPlot()`

5.  `glPlot()`: creates the ‘Gain/Loss’ plot using a CSV file as an
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

6.  `linePlot()`: creates a plot comparing two variables, such as ADEC
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
