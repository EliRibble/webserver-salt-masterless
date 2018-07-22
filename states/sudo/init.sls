sudo:
    pkg.installed

group_wheel:
    group.present:
        - name: wheel
        - system: True

/etc/sudoers.d/wheel:
    file.managed:
        - user: root
        - group: root
        - mode: 440
        - source: salt://sudo/wheel
