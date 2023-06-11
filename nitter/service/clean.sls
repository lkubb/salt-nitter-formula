# vim: ft=sls

{#-
    Stops the nitter, redis container services
    and disables them at boot time.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as nitter with context %}

nitter service is dead:
  compose.dead:
    - name: {{ nitter.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if nitter.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ nitter.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if nitter.install.rootless %}
    - user: {{ nitter.lookup.user.name }}
{%- endif %}

nitter service is disabled:
  compose.disabled:
    - name: {{ nitter.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if nitter.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ nitter.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if nitter.install.rootless %}
    - user: {{ nitter.lookup.user.name }}
{%- endif %}
