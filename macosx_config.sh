
#-------#
# ruby -#
#-------#

# I had to update ruby so that homebrew would work.
# Updated ruby based on instructions here: https://stackoverflow.com/questions/38194032/how-to-update-ruby-version-2-0-0-to-the-latest-version-in-mac-osx-yosemite

\curl -sSL https://get.rvm.io | bash -s stable

# Two notes (not sure if I need to do this)
# * To start using RVM you need to run `source /Users/benc/.rvm/scripts/rvm`
# in all your open shell windows, in rare cases you need to reopen all shell windows.
#
# * WARNING: '~/.profile' file found. To load it into your shell, add the following line to '/Users/benc/.bash_profile':#
#
#  source ~/.profile
  
rvm install ruby-2.4.2

#------------#
#--- brew ---#
#------------#

brew info <package> #lists a bunch of info about package, including install directory
brew list versions #list versions of all installed packages

#-------------------------------#
#--- software install/config ---#
#-------------------------------#

brew install miller

brew upgrade gdal #install gdal using brew 2019-06-04

#install qgis using osgeo brew tap 2019-06-04
brew tap osgeo/osgeo4mac
ulimit -n 1024
brew install osgeo/osgeo4mac/qgis #this didn't work

brew install osgeo-qgis #tried this instead

#----
#--- Mac-specific configuration ---#
#---

#prefs (.plist) are stored in two places
#https://www.makeuseof.com/tag/hidden-mac-settings-defaults-command/
~/Library/Preferences/ #user prefs
/Library/Preferences/ #system-wide prefs
