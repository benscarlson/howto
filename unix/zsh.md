zsh profile scripts. 

Not a lot of agreement on where things should go. https://stackoverflow.com/questions/23090390/is-there-anything-in-zsh-like-bash-profile

In general I think I should use .zshrc for things I will only use within zsh

* .zshenv - all invocations of the shell (login, non-login, interactive, non-interactive). For basic command paths and env variables
* .zprofile - meant as an alternative to .zlogin. ".zlogin is not the place for alias definitions, options, environment variable settings, etc.; as a general rule, it should not change the shell environment at all. Rather, it should be used to set the terminal type and run a series of external commands (fortune, msgs, etc)."
* .zshrc - for interactive shells

I have the following

* .zprofile
* .zshrc
