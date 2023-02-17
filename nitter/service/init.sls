# vim: ft=sls

{#-
    Starts the nitter, redis container services
    and enables them at boot time.
    Has a dependency on `nitter.config`_.
#}

include:
  - .running
