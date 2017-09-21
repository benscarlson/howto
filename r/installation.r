#---- loading packages ----
suppressPackageStartupMessages()

#---- package management ----

#if r says something like 'not available for xyz version'
#http://stackoverflow.com/questions/25721884/how-should-i-deal-with-package-xxx-is-not-available-for-r-version-x-y-z-wa
# see second answer
install.packages('hypervolume',dependencies=TRUE,repos='http://cran.rstudio.com/') #seems to install all dependencies, no matter what
install.packages('hypervolume',repos='http://cran.rstudio.com/') #this is probably faster

.libPaths() #see library paths. by default the first one is picked as the install location
#path seem to be built from here file below. see: http://stackoverflow.com/questions/6218358/how-do-i-set-r-libs-site-on-ubuntu-so-that-libpaths-is-set-properly-for-all-u
/etc/R/Renviron
#to install into a 'local' directory, these is a line like:
R_LIBS_USER=${R_LIBS_USER-'~/R/x86_64-pc-linux-gnu-library/3.2'}
#if the folder ~/R/x86_64-pc-linux-gnu-library/3.2 exists, then when you start R it will be the default place to install libraries

#my macbook pro
/Library/Frameworks/R.framework #r install from official installer
/Library/Frameworks/R.framework/Versions/Current #points to the latest version

old.packages() #check which packages are out of date
install.package('mypkg') #use install.packages to update an existing package.

#checks to see a set of libs are installed
checkInstalled <- function(libs) {
  for(lib in libs) {
    inst <- lib %in% rownames(installed.packages())
    writeLines(sprintf('Is %s installed? %s',lib,inst))
  }
}
#---- r configuration ----

#r 3.2.3 looks like it was installed by homebrew to /usr/local/Cellar/r/3.2.3. 'Cellar' is where brew puts your 'kegs'
brew list r
#https://support.rstudio.com/hc/en-us/articles/200486138-Using-Different-Versions-of-R
#I set environment variable RSTUDIO_WHICH_R to /usr/local/bin/R
#This link was set up by homebrew and links to /usr/local/Cellar/R/3.2.3/bin/R
