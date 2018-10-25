library(keyring)

#Mac program: keychain.app

#note: how is password set using keyring_create?
keyring_create('api_keys') #same as: file -> new keychain? I think I can set password using UI

#seems to be similar to: file -> new password item
key_set_with_value('google_maps', username = NULL, 
	password = '<password or key>',
  keyring = 'api_keys')

keyring::key_get('google_maps',keyring='api_keys')
#this will bring up a popup that says something like "store confidential information in rsession, and ask for password"
#keychain password is stored in lastpass.com
#supply password and click "allow", and it asks a few more times, then returns key
#subsequent key_get() will do the same
#but, supply passowrd and click "always" and subsequent key_get() does not require password

"R wants to use your confidential information stored in "google_maps" in your keychain."
