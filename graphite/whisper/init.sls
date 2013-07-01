include:
  - graphite

# Install Graphite Whisper via PIP

whisper:
  pip.installed:
    - require:
      - pkg: graphite-dependencies
      - pip: graphite-pip-dependencies

  file.managed:
    - name: /opt/graphite/conf/storage-schemas.conf
    - source: salt://graphite/whisper/opt/graphite/conf/storage-schemas.conf
