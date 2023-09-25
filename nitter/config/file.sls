# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as nitter with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

Nitter environment files are managed:
  file.managed:
    - names:
      - {{ nitter.lookup.paths.config_nitter }}:
        - source: {{ files_switch(
                        ["nitter.env", "nitter.env.j2"],
                        config=nitter,
                        lookup="nitter environment file is managed",
                        indent_width=10,
                     )
                  }}
      - {{ nitter.lookup.paths.config_redis }}:
        - source: {{ files_switch(
                        ["redis.env", "redis.env.j2"],
                        config=nitter,
                        lookup="redis environment file is managed",
                        indent_width=10,
                     )
                  }}
    - mode: '0640'
    - user: root
    - group: {{ nitter.lookup.user.name }}
    - makedirs: true
    - template: jinja
    - require:
      - user: {{ nitter.lookup.user.name }}
    - watch_in:
      - Nitter is installed
    - context:
        nitter: {{ nitter | json }}

Nitter config file is managed:
  file.managed:
    - name: {{ nitter.lookup.paths.config }}
    - source: {{ files_switch(
                    ["nitter.conf", "nitter.conf.j2"],
                    config=nitter,
                    lookup="Nitter config file is managed",
                 )
              }}
    - mode: '0644'
    - user: root
    - group: {{ nitter.lookup.user.name }}
    - makedirs: true
    - template: jinja
    - require:
      - user: {{ nitter.lookup.user.name }}
    - watch_in:
      - Nitter is installed
    - context:
        nitter: {{ nitter | json }}
