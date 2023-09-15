#----
#---- installation from code ----#
#----

#-- from local disk
library(devtools)
install_local('~/projects/anno',dependencies=FALSE,quiet=TRUE) #won't install unless code changed
library(anno)

#---- install package from command line, after devtools::build()
R CMD INSTALL ~/projects/anno_0.1.0.tar.gz #in case package needs to be re-installed

#-- from github

#-- private repo
# Setup a GitHub token to install R packages from a private repository: https://www.youtube.com/watch?v=LvzljgPrsjg

library(usethis)
gh_token_help()
create_github_token()
gitcreds::gitcreds_set()
remotes::install_github('my/repo',build_vignettes = T, auth_token=gh::gh_token())

#----
#---- developing packages
#----

#-- DESCRIPTION file

#add "Imports:" after "LazyData:", then add packages to import (seperated by commas). e.g.
Imports:
  httr,
  getPass

#if using dplyr, need to import the %>% function from magrittr. putting in DESCRIPTION is not enough.
@importFrom magrittr %>%

#update namespace file (required to export functions)
#if package is initially generated by rstudio, need to delete it before running this
devtools::document()

#---- options
options(a=10) #set option a to 10
getOption('a') #get value for option a

#----
#---- Example of Roxygen2 documentation format
#----

#' Downloads study metadata using movebank api
#'
#' @param studyid \code{integer} The id of the study
#' @param userid \code{string} Movebank user id
#' @return \code{tibble} A dataframe of information about the study
#' @examples
#' downloadStudy(<id>,"ben.s.carlson")
#' @export
#'

# Other Roxygen2 parameters

#' @importFrom readr read_csv
#' @import dplyr

#get the full path of a specified file in a package
system.file("external/test.grd", package="raster")

#after updating the package, do this in rstudio
devtools::document(); devtools::build()
R CMD INSTALL ~/projects/anno_0.1.0.tar.gz

#---- where to put r scripts ----#

#place in folder within inst. E.g. mypackage/inst/scripts/myscript.r
# when installed, will results in a mypackage/scripts folder
# use .libPaths() to find out where the package is installed to access script
# https://stackoverflow.com/questions/34044470/how-to-put-an-r-script-into-a-package

#---- initialization ----#
# use .onLoad function, put into a file called zzz.r
# See "When you do need side-effects" in http://r-pkgs.had.co.nz/r.html#style

/ignore #put files or folders here that should not be installed

#----
#---- Testing
#----

#---- setting breakpoints
devtools::document() #need to run document (and maybe build) to hit a breakpoint
devtools::build()
devtools::load_all() 
#try this to load package. otherwise, can directly source the function.
#then, directrly run a test case to walk through the code.

#---- Unit tests: http://r-pkgs.had.co.nz/tests.html
devtools::use_testthat() #set up unit tests

#---- make files in tests/testthat:
# e.g. make a file called test_myTests.r

context('myTests')

test_that('my test will work', {

  expect_true(
    1+1==2
  )
})

#manually run a unit test
devtools::document(); devtools::build(); devtools::load_all()
library(testthat)
#--> highlight and run the test

#Run automatic unit tests
devtools::document()
devtools::build()
devtools::test()

#----
#---- Troubleshooting
#----

#note, if you get something like "... *.rdb is corrupt" restart r session and try again
.rs.restartR()

#if strange exports are into the NAMESPACE file, make sure that there are no roxygen comments masqurading as regular comments
myfunction() {
  #' this will make weird exports!}
}
# downloadStudy.Rd is missing name/title. Skipping
# occurs if there is no description in roxygen block (i.e. the line "Download study metadata..." above)
