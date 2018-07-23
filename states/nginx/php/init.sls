php-dependencies:
    pkg.installed:
        - pkgs:
            - build-essential
            - curl
            - libcurl4-openssl-dev
            - php-dev
            - php-pear

php-cli:
    pkg.installed

php-fpm:
    pkg.installed:
        - name: php-fpm
    service.running:
        - name: php7.0-fpm
        - enable: True
    require:
        - pkg: curl

php-modules:
    pkg.installed:
        - pkgs:
            - php-gettext
            - php-curl
            - php-gd
            - php-intl
            - php-imagick
            - php-imap
            - php-mysql
            - php-tidy
            - php-zip

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
        - unless: pear list Mail
    require:
        - cmd: pear-upgrade
    

pear-install-smtp:
    cmd.run:
        - name: pear install --soft Net_SMTP
        - unless: pear list Net_SMTP
    require:
        - cmd: pear-upgrade

pecl-channel-update:
    cmd.run:
        - name: pecl channel-update pecl.php.net
    require:
        - pkg: php-modules
pecl-install-mcrypt:
    cmd.run:
        - name: pecl install mcrypt-1.0.1
        - unless: pecl list mcrypt
