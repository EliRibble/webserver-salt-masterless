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
            - php5-mysql
            - php5-curl
            - php5-gd
            - php5-intl
            - php5-imagick
            - php5-imap
            - php5-mcrypt
            - php5-tidy
            - php-gettext

/etc/nginx/conf.d/php-upstream.conf:
    file.managed:
        - source: salt://nginx/conf.d/php-upstream.conf
        - user: root
        - group: root
        - mode: 644
