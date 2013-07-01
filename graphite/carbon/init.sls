include:
  - graphite

# Install Graphite Carbon via PIP

carbon:
  pip.installed:
    - require:
      - pkg: graphite-dependencies
      - pip: graphite-pip-dependencies

  file.managed:
    - name: /opt/graphite/conf/carbon.conf
    - source: salt://graphite/carbon/opt/graphite/conf/carbon.conf
