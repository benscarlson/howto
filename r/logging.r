#http://logging.r-forge.r-project.org/sample_session.php

library(logging)

basicConfig()
addHandler(writeToFile, file='scratch/simtest.log', level='DEBUG')
addHandler(writeToConsole, level='DEBUG')

ls(getLogger())
getLogger()[['handlers']]

myf <- function() {
  loginfo('does it work?') 
}

myf() #can access logger set at top level

#Any logging record passing through a handler and having a severity lower than the level 
# of the handler is ignored

#CRITICAL 50
#ERROR    40
#WARNING  30
#INFO     20
#DEBUG    10 
#NOTSET   0
