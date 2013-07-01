include:
  - graphite.carbon

supervisord:
  pkg:
    - name: supervisor
    - installed

  file.managed:
    - name: /etc/supervisord.conf
    - source: salt://graphite/supervisor/etc/supervisord.conf
    - require:
      - pip: carbon
      - pkg: supervisor

  service.running:
    - enable: True
    - watch:
      - file: /etc/supervisord.conf
      - file: /opt/graphite/conf/carbon.conf
