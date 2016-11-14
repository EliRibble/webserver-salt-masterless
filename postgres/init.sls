pgdg:
    pkgrepo.managed:
        - humanname: PostgreSQL PPA
        - name: deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main
        - file: /etc/apt/sources.list.d/pgdg.list
        - key_url: https://www.postgresql.org/media/keys/ACCC4CF8.asc

postgresql-9.5:
    pkg.installed:
        - require:
            - pkgrepo: pgdg
    service.running:
        - name: postgresql
        - enable: True
        - restart: True

postgresql-contrib-9.5:
    pkg.installed:
        - require:
            - pkg: postgresql-9.5
