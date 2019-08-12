
sudo pip install earthengine-api --upgrade #upgrade a package
sudo pip install earthengine-api --upgrade --user #try using '--user' if you get a permissions denied error

pip show earthengine-api #show version
pip freeze | grep earthengine-api #version using older versions of pip

pip search earthengine-api #check for newer version (lots of output, look at top of output)
pip list -o | grep earthengine-api #also checks for newer version

