include:
  - sensu

# Sensu Dashboard Service

uchiwa:
  service.running:
    - enable: True
    - require:
      - pkg: sensu
      - pkg: uchiwa
  pkg:
    - installed
