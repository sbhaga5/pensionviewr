## code to prepare `dw` dataset goes here

# The folliwing url is provided by Heroku for a read-only user
url <- "postgres://reason_readonly:p88088bd28ea68027ee96c65996f7ea3b56db0e27d7c9928c05edc6c23ef2bc27@ec2-3-209-200-73.compute-1.amazonaws.com:5432/d629vjn37pbl3l"


# To parse the url into usable sections use parse_url
dw <- httr::parse_url(url)


usethis::use_data("dw")
