# vim: ft=sls

{#-
    *Meta-state*.

    This installs the nitter, redis containers,
    manages their configuration and starts their services.
#}

include:
  - .package
  - .config
  - .service
