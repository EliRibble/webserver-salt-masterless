/etc/nginx/sites-available/usw2-web.theribbles.org:
    file.managed:
        - source: salt://sites/files/usw2-web.theribbles.org
        - user: root
        - group: root
        - mode: 644

/etc/nginx/sites-enabled/usw2-web.theribbles.org:
    file.symlink:
        - target: /etc/nginx/sites-available/usw2-web.theribbles.org
