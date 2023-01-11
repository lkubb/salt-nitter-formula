# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as nitter with context %}

include:
  - {{ sls_service_clean }}

# This does not lead to the containers/services being rebuilt
# and thus differs from the usual behavior
Nitter environment files are absent:
  file.absent:
    - names:
      - {{ nitter.lookup.paths.config_nitter }}
      - {{ nitter.lookup.paths.config_redis }}
      - {{ nitter.lookup.paths.config }}
      - {{ nitter.lookup.paths.base | path_join(".saltcache.yml") }}
    - require:
      - sls: {{ sls_service_clean }}
