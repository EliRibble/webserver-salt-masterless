include:
    - python

/etc/uwsgi/apps-enabled:
    file.directory:
        - user: root
        - group: root
        - mode: 755
        - makedirs: true

/var/uwsgi:
    file.directory:
        - user: root
        - group: root
        - mode: 755

/opt/src/:
    file.directory

/opt/src/uwsgi-2.0.8:
    archive.extracted:
        - name: /opt/src/
        - source: http://projects.unbit.it/downloads/uwsgi-2.0.8.tar.gz
        - source_hash: md5=356b71060aa4c1f0e888dbca03567bd5
        - archive_format: tar
        - if_missing: /opt/src/uwsgi-2.0.8
        - require:
            - file: /opt/src/


uwsgi-python3-compile:
    cmd.run:
        - name: python3 uwsgiconfig.py --build
        - cwd: /opt/src/uwsgi-2.0.8
        - unless: ls /opt/src/uwsgi-2.0.8/uwsgi
        - require:
            - archive: /opt/src/uwsgi-2.0.8
            - pkg: libpython3.4-dev

uwsgi-python3-plugin-compile:
    cmd.run:
        - name: python3 uwsgiconfig.py --plugin plugins/python core python34
        - cwd: /opt/src/uwsgi-2.0.8
        - unless: ls /opt/src/uwsgi-2.0.8/python34_plugin.so
        - require:
            - archive: /opt/src/uwsgi-2.0.8

uwsgitop:
    pip.installed
