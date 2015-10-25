curl:
    pkg.installed:
        - pkgs:
            - curl
            - libcurl3
            - libcurl3-dev
            - php5-curl

php5-cli:
    pkg.installed

php5-fpm:
    pkg.installed:
        - name: php5-fpm
    service.running:
        - enable: True
    require:
        - pkg: curl

php5-mysql:
    pkg.installed

/etc/nginx/conf.d/php-upstream.conf:
    file.managed:
        - source: salt://nginx/conf.d/php-upstream.conf
        - user: root
        - group: root
        - mode: 644
