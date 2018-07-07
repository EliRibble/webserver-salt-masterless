# webserver-salt-masterless
Where I stuff my salt masterless config on my webserver.

# Bootstrapping a new server:

1. Install salt (https://repo.saltstack.com/#ubuntu):
 - `wget -O - https://repo.saltstack.com/apt/ubuntu/18.04/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -`
 - Add 'deb http://repo.saltstack.com/apt/ubuntu/18.04/amd64/latest bionic main' to `/etc/apt/sources.list.d/saltstack.list`
 - `sudo apt-get update`
 - `sudo apt-get install salt-minion`
2. Clone this repository
