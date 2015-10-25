include:
    - sudo

{% for user, user_data in pillar['users'].iteritems() %}
user-{{ user }}:
    user.present:
        - name: {{ user }}
        - password: 'DoNotUseAPasswordForAnything'
        - fullname: {{ salt['pillar.get']('users:' + user + ':fullname', 'No Name') }}
        - shell: {{ salt['pillar.get']('users:' + user + ':shell', '/bin/bash') }}
{% if 'groups' in pillar.users[user] %}
        - optional_groups:
{% for group in salt['pillar.get']('users:' + user + ':groups', []) %}
            - {{ group }}
{% endfor %}
{% endif %}
        - require:
            - group: group_wheel

cp-user-home-{{ user }}:
    file.recurse:
        - name: /home/{{ user }}
        - user: {{ user }}
        - group: {{ user }}
        - source: salt://users/{{ user }}
        - include_empty: True
        - require:
            - user: user-{{ user }}

{% if 'ssh_keys' in pillar['users'][user] %}
ssh_keys_{{ user }}:
    ssh_auth.present:
        - user: {{ user }}
        - names:
{% for ssh_key in salt['pillar.get']('users:' + user + ':ssh_keys', []) %}
            - {{ ssh_key }}
{% endfor %}
        - require:
            - user: user-{{ user }}
            - file: cp-user-home-{{ user }}
{% endif %}

{% endfor %}
