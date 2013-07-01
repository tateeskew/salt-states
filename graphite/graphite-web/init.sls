include:
  - graphite

# Install Graphite Web via PIP

graphite-web:
  pip.installed:
    - require:
      - pkg: graphite-dependencies
      - pip: graphite-pip-dependencies

# Manage configuration files

# Graphite Vhost

graphite-vhost:
  file.managed:
    - name: /etc/httpd/conf.d/graphite-vhost.conf 
    - source: salt://graphite/graphite-web/etc/httpd/conf.d/graphite-vhost.conf
    - require:
      - pip: graphite-web

# Graphite wsgi

graphite-wsgi:
  file.managed:
    - name: /opt/graphite/conf/graphite.wsgi
    - source: salt://graphite/graphite-web/opt/graphite/conf/graphite.wsgi
    - require:
      - pip: graphite-web

# Graphite local settings

graphite-local-settings:
  file.managed:
    - name: /opt/graphite/webapp/graphite/local_settings.py
    - source: salt://graphite/graphite-web/opt/graphite/webapp/graphite/local_settings.py
    - require:
      - pip: graphite-web

# Graphite django syncdb

syncdb:
  cmd.run:
    - name: /usr/bin/python manage.py syncdb --noinput
    - cwd: /opt/graphite/webapp/graphite
    - unless: test -e /opt/graphite/storage/graphite.db
    - require:
      - pip: graphite-web
      - file: graphite-local-settings

# Manage DB Permissions

/opt/graphite/storage/graphite.db:
  file.managed:
    - user: apache
    - group: apache
    - mode: 755
    - makedirs: True
    - require:
      - cmd: syncdb

graphite-storage-directory:
  file.directory:
    - names: 
      - /opt/graphite/storage
      - /opt/graphite/storage/lists
      - /opt/graphite/storage/rrd
      - /opt/graphite/storage/log
      - /opt/graphite/storage/whisper
      - /opt/graphite/storage/log/webapp
    - user: apache
    - group: apache
    - mode: 777
    - recurse:
      - user
      - group
    - require:
      - pip: graphite-web
