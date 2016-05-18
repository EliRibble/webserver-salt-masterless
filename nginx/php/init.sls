curl:
    pkg.installed:
        - pkgs:
            - curl
            - libcurl4-openssl-dev
            - php-curl

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

php-mysql:
    pkg.installed

/etc/nginx/conf.d/php-upstream.conf:
    file.managed:
        - source: salt://nginx/conf.d/php-upstream.conf
        - user: root
        - group: root
        - mode: 644
