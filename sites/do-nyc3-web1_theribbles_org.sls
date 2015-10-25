/etc/nginx/sites-available/do-nyc3-web1.theribbles.org:
    file.managed:
        - source: salt://sites/files/do-nyc3-web1.theribbles.org
        - user: root
        - group: root
        - mode: 644

/etc/nginx/sites-enabled/do-nyc3-web1.theribbles.org:
    file.symlink:
        - target: /etc/nginx/sites-available/do-nyc3-web1.theribbles.org
