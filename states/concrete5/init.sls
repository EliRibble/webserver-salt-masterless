{% for site in pillar.concrete5 %}
/etc/nginx/sites-available/{{ site }}:
    file.managed:
        - template: jinja
        - source: salt://concrete5/files/site.conf
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
