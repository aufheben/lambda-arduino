## About git subtree

It's easier to work with remotes because basically all the examples are shown
with remotes. Thus we create 2 repos on bitbucket for hArduino and lambda-arduino
first and add them as remotes for each local repo, and push whatever needs to be
pushed.

Then, from this repo:

    git remote add harduino git@bitbucket.org:aufheben/harduino.git
    git subtree add --prefix=packages/hArduino-0.9 harduino master

Reference: https://medium.com/@v/git-subtrees-a-tutorial-6ff568381844#.kvu4tucqm
