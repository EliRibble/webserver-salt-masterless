postgresql:
    pkg.installed:
        - name: postgresql
    service.running:
        - name: postgresql
        - enable: True
        - restart: True

postgresql-contrib:
    pkg.installed:
        - require:
            - pkg: postgresql
