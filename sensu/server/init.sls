include:
  - sensu
  - sensu.dependencies

# Sensu Server Service

sensu-server:
  service.running:
    - enable: True
    - require:
      - pkg: sensu
    - watch:
      - file: /etc/sensu/config.json
    - require:
      - service: redis-service

# Sensu Server config

sensu-config-file:
  file.managed:
    - name: /etc/sensu/config.json
    - source: salt://sensu/server/etc/sensu/config.json
    - template: jinja
