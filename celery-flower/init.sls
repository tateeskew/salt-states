# State for Celery Flower - https://github.com/mher/flower

install-celery-flower:
  pip.installed:
    - name: flower

celery-flower-supervisor:
  pkg.installed:
    - name: supervisor
  service.running:
    - name: supervisor
    - enable: True
    - watch:
      - file: /etc/supervisor/conf.d/celery-flower.conf

/etc/supervisor/conf.d/celery-flower.conf:
  file.managed:
    - source: salt://celery-flower/etc/supervisor/conf.d/celery-flower.conf
    - template: jinja
    - require:
      - pkg: celery-flower-supervisor
