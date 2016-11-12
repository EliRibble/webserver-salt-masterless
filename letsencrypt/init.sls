ssl-cert-check:
    pkg.installed

letsencrypt:
    pip.installed

/usr/sbin/certbot-auto:
    file.managed:
        - source: https://dl.eff.org/certbot-auto
        - source_hash: md5=e3848b764200e645b97576a4983213f6
        - user: root
        - mode: 755
        - group: root

/usr/local/bin/letsencrypt-renew.sh:
    file.managed:
        - source: salt://letsencrypt/files/letsencrypt-renew.sh
        - mode: 755
        - user: root
        - group: root
        - require:
            - file: /usr/sbin/certbot-auto

/usr/local/bin/letsencrypt-initial.sh:
    file.managed:
        - source: salt://letsencrypt/files/letsencrypt-initial.sh
        - mode: 755
        - user: root
        - group: root
        - require:
            - file: /usr/sbin/certbot-auto

/var/log/letsencrypt:
    file.directory:
        - user: root
        - group: root

/etc/letsencrypt:
    file.directory:
        - user: root
        - group: root

/etc/letsencrypt/configs:
    file.directory:
        - user: root
        - group: root
        - require:
            - file: /etc/letsencrypt

/var/www/letsencrypt:
    file.directory:
        - user: www-data
        - group: www-data
        - makedirs: True

{% for site in pillar.get('applications', {}).keys() %}
/etc/letsencrypt/configs/{{ site }}.conf:
    file.managed:
        - source: salt://letsencrypt/files/site.conf
        - user: root
        - group: root
        - mode: 644
        - context:
            site: {{ site }}
        - template: jinja
        - require:
            - file: /etc/letsencrypt/configs

/var/www/letsencrypt/{{ site }}/:
    file.directory:
        - user: www-data
        - group: www-data
        - mode: 755
        - require:
            - file: /var/www/letsencrypt

{{ site }}-auto-renewal:
    cron.present:
        - name: /usr/local/bin/letsencrypt-renew.sh {{ site }} && nginx -s reload
        - identifier: {{ site }}-renewal
        - user: root
        - minute: random
        - hour: 2
        - daymonth: 1
        - month: "JAN,MAR,MAY,JUL,SEP,NOV"
        - comment: 'Renew {{ site }} SSL certificate every 2 months'
{% endfor %}
