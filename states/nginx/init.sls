nginx:
    pkg.installed:
        - name: nginx
    service.running:
        - enable: True
        - restart: True
        - watch:
            - file: /etc/nginx/*

/var/www:
    file.directory:
        - user: www-data
        - group: www-data

default-nginx:
    file.absent:
        - name: /etc/nginx/sites-enabled/default
    require:
        - pkg: nginx

/etc/nginx/nginx.conf:
    file.managed:
        - source: salt://nginx/nginx.conf
        - user: root
        - group: root
        - mode: 644

/etc/nginx/fastcgi_params:
    file.managed:
        - source: salt://nginx/fastcgi_params
        - user: root
        - group: root
        - mode: 644

/etc/nginx/sites-available/drop-bad-host.conf:
    file.managed:
        - source: salt://nginx/drop-bad-host.conf
        - user: root
        - group: root
        - mode: 644
