#if r says something like 'not available for xyz version'
#http://stackoverflow.com/questions/25721884/how-should-i-deal-with-package-xxx-is-not-available-for-r-version-x-y-z-wa
# see second answer
install.packages('hypervolume',dependencies=TRUE,repos='http://cran.rstudio.com/')
