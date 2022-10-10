
#---- run R from command line ----
R CMD BATCH test.r #run file test.R from the command line
R --slave -f test.r #also run from the command line
Rscript <script_name.r>

#add this to top of script to run directly from the command line
#!/usr/bin/env Rscript
#make executable
chmod 744 myscript.r #this will result in rwxr--r--

# get commandline arguments within a script
args <- commandArgs(trailingOnly=TRUE)
datName <- args[1]
if(is.na(datName)) stop('datName required')

#---- docopt ----#

#For boolean option, need to have more than one space (or a tab) after the variable or it will not work correctly

#One space
-u --use Use an existing session
# * will be null if not set
# * will throw an error if set

#Two spaces or a tab
-u --use  Use an existing session

#boolean values are already logical data type, dont need to set
as.logical(ag$use) #Don't need to do this
