include:
  - sensu

# Sensu Dashboard Service

sensu-dashboard:
  service.running:
    - enable: True
    - require:
      - pkg: sensu
