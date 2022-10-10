# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as nitter with context %}

include:
  - {{ sls_config_clean }}

{%- if nitter.install.autoupdate_service %}

Podman autoupdate service is disabled for Nitter:
{%-   if nitter.install.rootless %}
  compose.systemd_service_disabled:
    - user: {{ nitter.lookup.user.name }}
{%-   else %}
  service.disabled:
{%-   endif %}
    - name: podman-auto-update.timer
{%- endif %}

Nitter is absent:
  compose.removed:
    - name: {{ nitter.lookup.paths.compose }}
    - volumes: {{ nitter.install.remove_all_data_for_sure }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if nitter.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ nitter.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if nitter.install.rootless %}
    - user: {{ nitter.lookup.user.name }}
{%- endif %}
    - require:
      - sls: {{ sls_config_clean }}

Nitter compose file is absent:
  file.absent:
    - name: {{ nitter.lookup.paths.compose }}
    - require:
      - Nitter is absent

Nitter user session is not initialized at boot:
  compose.lingering_managed:
    - name: {{ nitter.lookup.user.name }}
    - enable: false
    - onlyif:
      - fun: user.info
        name: {{ nitter.lookup.user.name }}

Nitter user account is absent:
  user.absent:
    - name: {{ nitter.lookup.user.name }}
    - purge: {{ nitter.install.remove_all_data_for_sure }}
    - require:
      - Nitter is absent
    - retry:
        attempts: 5
        interval: 2

{%- if nitter.install.remove_all_data_for_sure %}

Nitter paths are absent:
  file.absent:
    - names:
      - {{ nitter.lookup.paths.base }}
    - require:
      - Nitter is absent
{%- endif %}
