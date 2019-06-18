
#---- run R from command line ----
R CMD BATCH test.r #run file test.R from the command line
R --slave -f test.r #also run from the command line
Rscript <script_name.r>
#add this to top of script to run directly from the command line
#!/usr/bin/env Rscript

# get commandline arguments within a script
args <- commandArgs(trailingOnly=TRUE)
datName <- args[1]
if(is.na(datName)) stop('datName required')


