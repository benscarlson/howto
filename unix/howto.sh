nohup <command> & #what is the command for running a nohup job? 
jobs OR jobs -l #if you are still logged into the same shell, use: 
ps -ef | grep "<part of command name>" to find the pid #if you have exited out of the shell use
kill -9 <pid> #to kill the process
