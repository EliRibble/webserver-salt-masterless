include:
    - nginx
    - supervisor
    - uwsgi
    
{% for site, spec in pillar.get('applications', {}).items() %}
{{ site }}-database:
    cmd.run:
        - name: createdb {{ spec.db.name }}
        - runas: postgres
        - unless: psql -l | grep {{ spec.db.name }} | wc -l


{{ site }}-db-user:
    cmd.run:
        - name: psql -d {{ spec.db.name }} -c "CREATE USER {{ spec.db.user }} WITH PASSWORD '{{ spec.db.password }}';"
        - runas: postgres
        - unless: psql -d {{ spec.db.name }} -c "SELECT 1 FROM pg_roles WHERE rolname='{{spec.db.name}}'"

{{ site }}-db-privileges:
    cmd.run:
        - name: psql -d {{ spec.db.name }} -c "GRANT ALL PRIVILEGES ON DATABASE {{ spec.db.name }} to {{ spec.db.user }};"
        - runas: postgres

/etc/nginx/sites-available/{{ site }}.conf:
    file.managed:
        - user: www-data
        - group: www-data
        - mode: 660
        - source: salt://applications/files/site.conf.template
        - template: jinja
        - context:
            site: {{ site }}
        - require:
            - pkg: nginx

/etc/nginx/sites-enabled/{{ site }}.conf:
    file.symlink:
        - target: /etc/nginx/sites-available/{{ site }}.conf
        - require:
            - file: /etc/nginx/sites-available/{{ site }}.conf


/etc/supervisor/conf.d/{{ site }}.uwsgi.conf:
    file.managed:
        - user: root
        - group: root
        - mode: 644
        - source: salt://applications/files/uwsgi.conf.template
        - template: jinja
        - context:
            processname: {{ site }}
        - require:
            - pkg: supervisor

supervisor.{{ site }}:
    supervisord:
        - name: {{ site }}
        - running
        - watch:
            - file: /etc/supervisor/conf.d/{{ site }}.uwsgi.conf
        - require:
            - file: /etc/supervisor/conf.d/{{ site }}.uwsgi.conf

/etc/uwsgi/apps-enabled/{{ site }}.ini:
    file.managed:
        - source: salt://applications/files/app.ini.template
        - context:
            app: {{ site }}
            spec: {{ spec|yaml }}
        - user: root
        - group: root
        - mode: 644
        - template: jinja
        - require:
            - file: /etc/uwsgi/apps-enabled

{% endfor %}

{% if pillar.get('applications', {}) %}
supervisor.reread:
    cmd.run:
        - name: supervisorctl reread; supervisorctl update
        - onchanges:
            {% for site in pillar.get('applications', {}).keys() %}
            - file: /etc/supervisor/conf.d/{{ site }}.uwsgi.conf
            {% endfor %}
{% endif %}
