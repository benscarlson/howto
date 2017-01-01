
#get the last commit
git rev-parse HEAD #5e152f31b4e0d4fe45403d822cd785da888e0431
git log -1 --format='%H' #5e152f31b4e0d4fe45403d822cd785da888e0431
git log --pretty=format:'%h' -n 1 #5e152f3 (short version?)

