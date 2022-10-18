~/.ssh/id_rsa #private key
~/.ssh/id_rsa.pub #public key

#For additional keys, add the host name as a suffix. e.g.
~/.ssh/id_rsa_grace #private key

#delte an entry from known_hosts
ssh-keygen -R hostname
