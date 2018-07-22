postgresql:
    pkg.installed:
        - name: postgresql-10
    service.running:
        - name: postgresql
        - enable: True
        - restart: True

postgresql-contrib:
    pkg.installed:
        - require:
            - pkg: postgresql
