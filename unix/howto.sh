nohup <command> & #what is the command for running a nohup job? 
jobs OR jobs -l #if you are still logged into the same shell, use: 
ps -ef | grep "<part of command name>" to find the pid #if you have exited out of the shell use
kill -9 <pid> #to kill the process
chown -R benc:benc data #change the user and group permissions for folder "data" to user: benc group: benc. also works on files

.bash_pofile #used for login shell (i.e remote in via ssh)
.bashrc #used for non-login shell (i.e. opening another shell after you've already logged in)
