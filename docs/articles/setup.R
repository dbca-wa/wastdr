## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  eval = FALSE,
  comment = "#>"
)

## ---- message=FALSE------------------------------------------------------
#  require(wastdr)

## ----eval=F--------------------------------------------------------------
#  wastdr::get_wastd('encounters',
#                    api_token = "asdfqwer1234")
#  
#  wastdr::get_wastd('encounters',
#                    api_un = "my_usernname",
#                    api_pw = "my_password")

## ------------------------------------------------------------------------
#  wastdr::wastdr_setup(api_token = "c12345asdfqwer")

## ------------------------------------------------------------------------
#  wastdr::wastdr_setup(api_un = "my_username", api_pw = "my_password")

## ------------------------------------------------------------------------
#  wastdr::wastdr_settings()

## ------------------------------------------------------------------------
#  Sys.setenv(WASTDR_API_TOKEN="Token c1234")

## ------------------------------------------------------------------------
#  Sys.setenv(WASTDR_API_UN="my_username")
#  Sys.setenv(WASTDR_API_PW="my_password")

