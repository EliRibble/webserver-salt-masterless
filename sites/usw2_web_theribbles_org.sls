/etc/nginx/sites-available/usw2-web.theribbles.org:
    file.managed:
        - source: salt://sites/files/usw2-web.theribbles.org
        - user: root
        - group: root
        - mode: 644

/etc/nginx/sites-enabled/usw2-web.theribbles.org:
    file.symlink:
        - target: /etc/nginx/sites-available/usw2-web.theribbles.org

/var/www/usw2-web.theribbles.org:
    file.directory:
        - user: www-data
        - group: www-data
        
/var/www/usw2-web.theribbles.org/index.php:
    file.managed:
        - source: salt://sites/files/index.php
        - user: www-data
        - group: www-data
        - mode: 440
        - require:
            - file: /var/www/usw2-web.theribbles.org

