# vim: ft=yaml
---
nitter:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    compose:
      create_pod: null
      pod_args: null
      project_name: nitter
      remove_orphans: true
      build: false
      build_args: null
      pull: false
      service:
        container_prefix: null
        ephemeral: true
        pod_prefix: null
        restart_policy: on-failure
        restart_sec: 2
        separator: null
        stop_timeout: null
    paths:
      base: /opt/containers/nitter
      compose: docker-compose.yml
      config_nitter: nitter.env
      config_redis: redis.env
      config: nitter.conf
    user:
      groups: []
      home: null
      name: nitter
      shell: /usr/sbin/nologin
      uid: null
      gid: null
    containers:
      nitter:
        image: docker.io/zedeus/nitter:latest
      redis:
        image: docker.io/library/redis:6-alpine
  install:
    rootless: true
    autoupdate: true
    autoupdate_service: false
    remove_all_data_for_sure: false
    podman_api: true
  config:
    cache:
      listMinutes: 240
      redisConnections: 20
      redisHost: nitter-redis
      redisMaxConnections: 30
      redisPassword: ''
      redisPort: 6379
      rssMinutes: 10
    config:
      base64Media: false
      enableDebug: false
      enableRSS: true
      hmacKey: null
      proxy: ''
      proxyAuth: ''
      tokenCount: 10
    preferences:
      autoplayGifs: true
      bidiSupport: false
      hideBanner: false
      hidePins: false
      hideReplies: false
      hideTweetStats: false
      hlsPlayback: false
      infiniteScroll: false
      mp4playback: true
      muteVideos: false
      proxyVideos: true
      replaceInstagram: bibliogram.art
      replaceReddit: teddit.net
      replaceTwitter: nitter.net
      replaceYouTube: piped.kavin.rocks
      squareAvatars: false
      stickyProfile: true
      theme: Nitter
    server:
      address: 0.0.0.0
      hostname: localhost
      httpMaxConnections: 100
      https: false
      port: 1773
      staticDir: ./public
      title: nitter

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://nitter/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   nitter-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      Nitter environment file is managed:
      - nitter.env.j2

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
