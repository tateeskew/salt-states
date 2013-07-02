include:
  - sensu
  
# Sensu API Service

sensu-api:
  service.running:
    - enable: True
    - require:
      - pkg: sensu
