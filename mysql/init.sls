mysql-server-5.6:
    pkg.installed

python-mysqldb:
    pkg.installed

{% for database, spec in pillar.mysql.items() %}
mysql-db-{{database}}:
    mysql_database.present:
        - name: {{database}}
        - require:
            - pkg: python-mysqldb

mysql-user-{{spec.username}}:
    mysql_user.present:
        - name: {{spec.username}}
        - host: {{spec.host}}
        - password: {{spec.password}}
        - require:
            - mysql_database: mysql-db-{{database}}

mysql-grant-{{spec.username}}:
    mysql_grants.present:
        - grant: 'ALL PRIVILEGES'
        - database: {{ database }}.*
        - user: {{ spec.username }}
        - host: {{ spec.host }}
        - require:
            - mysql_user: mysql-user-{{spec.username}}
{% endfor %}
        
