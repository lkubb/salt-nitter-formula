# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_file = tplroot ~ ".config.file" %}
{%- from tplroot ~ "/map.jinja" import mapdata as nitter with context %}

include:
  - {{ sls_config_file }}

Nitter service is enabled:
  compose.enabled:
    - name: {{ nitter.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if nitter.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ nitter.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
    - require:
      - Nitter is installed
{%- if nitter.install.rootless %}
    - user: {{ nitter.lookup.user.name }}
{%- endif %}

Nitter service is running:
  compose.running:
    - name: {{ nitter.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if nitter.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ nitter.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if nitter.install.rootless %}
    - user: {{ nitter.lookup.user.name }}
{%- endif %}
    - watch:
      - Nitter is installed
      - sls: {{ sls_config_file }}
