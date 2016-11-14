
#get the last commit (long version)
git rev-parse HEAD
git log --pretty=format:'%h' -n 1

#get the last commit (long version)
git rev-parse --short HEAD
git log --pretty=format:'%H' -n 1
