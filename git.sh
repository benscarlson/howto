#--- clone existing git repo ---#
cd ~/projects
git clone git@github.com:benscarlson/repo.git

git clone git@github.com:repo.git myrepo #instead of cloning to folder 'repo' this will clone to folder 'myrepo'

#To clone a branch
#First clone the main repo, as above
git branch -a #This shows remote branches (e.g. remotes/origin/mybranch)
git checkout mybranch #This sets up a local branch to track origin's mybranch, and switches to that branch

#Execute a git command when not in the directory containing the .git repo
git -C myrepodir

#--- add non-repo code to a new github repo ---#
#first, go to github.com and create the repo "anno" on github, don't initialize
cd ~/projects/anno/src
git init
git status
#set up .gitignore. See below
git add .
git remote add origin git@github.com:benscarlson/anno.git
git commit -am 'initial commit'
git push -u origin master

#--- add existing local repo to github ---#
#first, go to github.com and create the repo "anno" on github, don't initialize
cd ~/projects/anno
git remote add origin git@github.com:benscarlson/anno.git
#make sure that git repo has something in it!
git add .
git commit -am 'initial commit'
git push -u origin master

#--- change a repo name ---#

#go to github and change the name
#the old name will still forward to the new name
git remote set-url origin git@github.com:/benscarlson/movedb.git #update the target repo on local repositories. don't have to but recommended.

# Untrack a file from the repo but leave on disk
git rm --cached your_filename

#get the last commit
git rev-parse HEAD #5e152f31b4e0d4fe45403d822cd785da888e0431
git log -1 --format='%H' #5e152f31b4e0d4fe45403d822cd785da888e0431
git log --pretty --format='%h' -n 1 #5e152f3 (short version?)

#To see a repo using a specific hash in github, go to upper right above the file list (e.g "25 commits"). Click on this to see the history.

#--- Submodules ---#

git submodule add [submodule-repository-url] [path]
git submodule add git@github.com:bblonder/hypervolume.git

#---- SSH Keys ----#

#How to generate an ssh key and add it to github
#https://gist.github.com/adamjohnson/5682757
cd ~/.ssh
ssh-keygen -t rsa -C "your_email@example.com"

# add ssh key to github
# https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account
ls -al ~/.ssh #check ssh director for ssh key
cat ~/.ssh/id_rsa.pub #print out contents of rsa key and copy the text
# go to github and add a key by pasting the contents

#---- Branches ----#

#https://thenewstack.io/dont-mess-with-the-master-working-with-branches-in-git-and-github/

git branch -a #Shows all branches and which is the current branch
git checkout -b mybranch #Creates the branch and switches to that branch
git checkout mybranch #switch to mybranch

#to merge back to main
git checkout main
git merge -–no-ff mybranch

git branch --merged #see which branches have been merged into the current branch
git branch -d mybranch #delete my branch

#If the current branch does not exist on origin you set an upstream branch and then push
git push --set-upstream origin mybranch

#---- how to stage a pull request ----
#note if master branch is selected and you make changes, and you want to commit changes to a local branch
# you can still follow the steps below. The key is just don't commit your changes to the master branch. Create
# your own branch and then commit. Overall, it's probably best practice to make a branch first and switch to that
# branch before making any changes.

git branch mybranch # create new branch
git checkout mybranch # switch to new branch
git branch #shows you current branch

git commit -am 'my message' # make changes and commit to local branch
git push -u origin mybranch # set up a branch on github that will track your local branch.
# go to github and make a pull request

#---- What to do to your local repo after pull request has been merged
# maintainer will merge branch into master, and delete remote branch
git pull # get the latest (assuming you are on master branch)
git branch -d mybranch # delete local branch

#---- Display logs ----#
#Some pretty ways to show commit history
git log --graph --oneline --decorate --all #This prints out the commits
git log --topo-order --all --graph --date=local --pretty=format:'%C(green)%h%C(reset) %><(55,trunc)%s%C(red)%d%C(reset) %C(blue)[%an]%C(reset) %C(yellow)%ad%C(reset)%n'

#can make alias for a command
git config --global alias.mycmd 'git command'
git mycmd #is now aliased to 'git command'

#---- .gitignore
echo ".DS_Store" >> .gitignore
echo ".RData" >> .gitignore
echo ".RHistory" >> .gitignore
echo ".Rproj.user" >> .gitignore

