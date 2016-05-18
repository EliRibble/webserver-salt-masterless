/var/www/usw2-web.theribbles.org/index.php:
    file.managed:
        - source: salt://sites/files/index.php
        - user: www-data
        - group: www-data
        - mode: 440
        - require:
            - file: /var/www/usw2-web.theribbles.org

{% for site in pillar.sites %}
/etc/nginx/sites-available/{{ site }}:
    file.managed:
        - template: jinja
        - source: salt://sites/files/site.conf
        - user: root
        - group: root
        - mode: 644
        - context:
            server_name: {{ site }}

/etc/nginx/sites-enabled/{{ site }}:
    file.symlink:
        - target: /etc/nginx/sites-available/{{ site }}

/var/www/{{ site }}:
    file.directory:
        - user: www-data
        - group: www-data
        
{% endfor %}
