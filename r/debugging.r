#https://jozef.io/r916-exploring-r-code-interactively/

debug(order) #when order() is called, r will break into the debugger
undebug(order) #remove debug call
debugonce(order) #will just debug once, no need to call undebug()

debugonce(blogdown:::list_rmds) #debug an unexported function

body(stats::aggregate) #this will list the code of the function

#this will call the data.frame version of aggregate, instead of the generic form
eval(debugcall(
  aggregate(mtcars["hp"], mtcars["carb"], FUN = mean),
  once = TRUE
))

#stop a function at a specific line of code
as.list(body(stats::aggregate.data.frame)) #see all lines of code from aggregate
trace(stats::aggregate.data.frame, tracer = browser, at = 21) #insert a debug call at line 21
untrace(stats::aggregate.data.frame) #remove the trace

#---- debugging r library code ----

# maybe make a branch since you need to add browser() statements

browser() # add browser() to the code
devtools::load_all(path/to/code) # reload the package

# now the debugger will stop at the browser statement
