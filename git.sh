
#get the last commit
git rev-parse HEAD #5e152f31b4e0d4fe45403d822cd785da888e0431
git log -1 --format='%H' #5e152f31b4e0d4fe45403d822cd785da888e0431
git log --pretty --format='%h' -n 1 #5e152f3 (short version?)

git clone git@github.com:repo.git myrepo #instead of cloning to folder 'repo' this will clone to folder 'myrepo'

git checkout mybranch #switch to mybranch
git branch --merged #see which branches have been merged into the current branch
git branch -d mybranch #delete my branch

# make changes, save to branch
# make pull request
# maintainer will merge branch into master, and delete remote branch
git pull # get the latest (assuming you are on master branch)
git branch -d mybranch # delete local branch
