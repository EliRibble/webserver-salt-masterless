{% for site in pillar.wordpress %}
/etc/nginx/sites-available/{{ site }}:
    file.managed:
        - template: jinja
        - source: salt://wordpress/files/site.conf
        - user: root
        - group: root
        - mode: 644
        - context:
            site: {{ site }}

/etc/nginx/sites-enabled/{{ site }}:
    file.symlink:
        - target: /etc/nginx/sites-available/{{ site }}

/var/www/{{ site }}:
    file.directory:
        - user: www-data
        - group: www-data
        - recurse:
            - user
            - group
{% endfor %}
