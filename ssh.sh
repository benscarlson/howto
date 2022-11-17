~/.ssh/id_rsa #private key
~/.ssh/id_rsa.pub #public key

#For additional keys, add the host name as a suffix. e.g.
~/.ssh/id_rsa_grace #private key

#delte an entry from known_hosts
ssh-keygen -R hostname

#avoid always typing passphrase
#add a key to ssh-agent 
eval `ssh-agent -s` #start the agent

ssh-add id_rsa #add the rsa token
ssh-add -K ~/.ssh/id_rsa #on a mac, need to use the -K to add your passphrase to the keychain.
ssh-add -l #see what is added to ssh-agent
