# webserver-salt-masterless
Where I stuff my salt masterless config on my webserver.

# Bootstrapping a new server:

1. Install salt (https://repo.saltstack.com/#ubuntu):
 - `wget -O - https://repo.saltstack.com/apt/ubuntu/18.04/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -`
 - Add 'deb http://repo.saltstack.com/apt/ubuntu/18.04/amd64/latest bionic main' to `/etc/apt/sources.list.d/saltstack.list`
 - `sudo apt-get update`
 - `sudo apt-get install salt-minion`
2. Clone this repository
 - You may need to add a new SSH key
  - ssh-keygen '...'
  - upload to Github
 - `sudo apt-get install git`
 - git clone git@github.com:EliRibble/webserver-salt-masterless.git 
3. Set up salt
 - make `/etc/salt/minion` contain:
```
file_client: local
id: webserver
file_roots:
    base:
        - /srv/salt/states
pillar_roots:
    base:
        - /srv/salt/pillars
```
 - `sudo mkdir /srv/salt`
 - `ln -s /home/eliribble/src/webserver-salt-masterless/top.sls /srv/salt/top.sls`
 - `sudo salt-call --local test.ping`
4. Check that a safe state can apply
 - `sudo salt-call --local state.apply nginx -l debug`
 - This may not actually get nginx working yet because of how the recipes are structured
5. Add some pillars
 - You'll need a top.sls. It should look like this:
```
base:
	'*':
		- mysql
		- sites
        - users
```
 - You'll need to populate mysql.sls. It should look like this:
```
mysql:
	anythingforafriend_c5:
		host: localhost
		username: <username>
		password: <password>
	ncloward_free2beproductions_c5:
		host: localhost
		username: <username>
		password: <password>
	cupcakes_c5:
		...
	thehumanascent_c5:
		...
```
 - The sites.sls file:
```
sites:
	- usw2-web.theribbles.org
	- theribbles.org
	- www.theribbles.org

applications:
	www.whatkingdomtoday.com:
		db:
			name: dominus
			user: <user>
			password: <password>
		wsgifile: /opt/src/www.whatkingdomtoday.com/dominus/wsgihandler.py
	whatkingdomtoday.com:
		<same as above>
concrete5:
	- anythingforafriend.com
	- cuttingedgetreepros.com
	- free2beproductions.com
	- sweetcharitys.com
	- thehumanascent.com

wordpress:
	- blog.sweetcharitys.com
	- blog.theribbles.org
	- forums.thehumanascent.com
	- thales.thehumanascent.com
```
 - The users.sls file:
```
users:
	eliribble:
		fullname: Eli Ribble
		shell: /bin/bash
		groups:
			- wheel
			- www-data
		ssh_keys:
			- ssh-rsa <content> <username>
	nickcloward:
		<as above>
```
6. Get some pillars up and running. It's hard to get all the pillars correct right off the bat, so feel free to apply them in the following order:
 - users
 - mysql
 - nginx
 - nginx.php
 - postgres
 - concrete5
 - wordpress

Testing:
base:
 - applications

7. Migrating sites to a new server (Wordpress)
 - `tar -czvf /tmp/blog.sweetcharitys.com.tgz -C /var/www /var/www/blog.sweetcharitys.com`
 - Use scp to move the file to the new server
 - `tar -xzvf blog.sweetcharitys.com.tgz 
 - `mysqldump --user <db user> -p thehumanascent_c5 | gzip > thehumanascent_c5.sql.gz`
 - Use scp to move the file to the new server
 - `gzip -d thehumanascent_c5.sql.gz`
 - `mysql -u <db user> -p thehumanascent_c5 < thehumanascent_db.sql`
