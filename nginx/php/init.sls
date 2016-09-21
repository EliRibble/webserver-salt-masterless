curl:
    pkg.installed:
        - pkgs:
            - curl
            - libcurl4-openssl-dev

php5-cli:
    pkg.installed

php5-fpm:
    pkg.installed:
        - name: php5-fpm
    service.running:
        - name: php5-fpm
        - enable: True
    require:
        - pkg: curl

php-modules:
    pkg.installed:
        - pkgs:
            - php-gettext
            - php-pear
            - php5-curl
            - php5-dev
            - php5-gd
            - php5-intl
            - php5-imagick
            - php5-imap
            - php5-mcrypt
            - php5-mysql
            - php5-tidy

/etc/nginx/conf.d/php-upstream.conf:
    file.managed:
        - source: salt://nginx/conf.d/php-upstream.conf
        - user: root
        - group: root
        - mode: 644

pear-channel-update:
    cmd.run:
        - name: pear channel-update pear.php.net
    require:
        - pkg: php-modules

pear-upgrade:
    cmd.run:
        - name: pear upgrade-all
    require:
        - cmd: pear-channel-update

pear-install-mail:
    cmd.run:
        - name: pear install --soft Mail
    require:
        - cmd: pear-upgrade

pear-install-smtp:
    cmd.run:
        - name: pear install --soft Net_SMTP
    require:
        - cmd: pear-upgrade
