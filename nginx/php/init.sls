curl:
    pkg.installed:
        - pkgs:
            - curl
            - libcurl4-openssl-dev

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
            - php7.0-mysql
            - php7.0-curl
            - php7.0-gd
            - php7.0-intl
            - php-imagick
            - php7.0-imap
            - php7.0-mcrypt
            - php7.0-tidy
            - php-gettext

/etc/nginx/conf.d/php-upstream.conf:
    file.managed:
        - source: salt://nginx/conf.d/php-upstream.conf
        - user: root
        - group: root
        - mode: 644
