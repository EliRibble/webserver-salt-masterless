/etc/ssh/sshd_config:
    file.managed:
        - source: salt://ssh/sshd_config
        - user: root
        - group: root
        - mode: 644

ssh:
    service:
        - running
        - enable: True
        - reload: True
        - watch:
            - file: /etc/ssh/sshd_config
