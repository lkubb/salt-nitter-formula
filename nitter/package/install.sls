# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as nitter with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

Nitter user account is present:
  user.present:
{%- for param, val in nitter.lookup.user.items() %}
{%-   if val is not none and param != "groups" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - usergroup: true
    - createhome: true
    - groups: {{ nitter.lookup.user.groups | json }}
    # (on Debian 11) subuid/subgid are only added automatically for non-system users
    - system: false

Nitter user session is initialized at boot:
  compose.lingering_managed:
    - name: {{ nitter.lookup.user.name }}
    - enable: {{ nitter.install.rootless }}
    - require:
      - user: {{ nitter.lookup.user.name }}

Nitter paths are present:
  file.directory:
    - names:
      - {{ nitter.lookup.paths.base }}
    - user: {{ nitter.lookup.user.name }}
    - group: {{ nitter.lookup.user.name }}
    - makedirs: true
    - require:
      - user: {{ nitter.lookup.user.name }}

Nitter compose file is managed:
  file.managed:
    - name: {{ nitter.lookup.paths.compose }}
    - source: {{ files_switch(['docker-compose.yml', 'docker-compose.yml.j2'],
                              lookup='Nitter compose file is present'
                 )
              }}
    - mode: '0644'
    - user: root
    - group: {{ nitter.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
    - makedirs: true
    - context:
        nitter: {{ nitter | json }}

Nitter is installed:
  compose.installed:
    - name: {{ nitter.lookup.paths.compose }}
{%- for param, val in nitter.lookup.compose.items() %}
{%-   if val is not none and param != "service" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
{%- for param, val in nitter.lookup.compose.service.items() %}
{%-   if val is not none %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - watch:
      - file: {{ nitter.lookup.paths.compose }}
{%- if nitter.install.rootless %}
    - user: {{ nitter.lookup.user.name }}
    - require:
      - user: {{ nitter.lookup.user.name }}
{%- endif %}
