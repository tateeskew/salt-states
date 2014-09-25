#
# Sensu Dependencies
#
# Tate Eskew
#
# NOTE: Please remember to put your sensu RabbitMQ user password in a corresponding pillar file
#       before implementing this state.

# Install Erlang

erlang:
  pkg.installed:
    {% if grains['os'] == 'RedHat' or grains['os'] == 'Fedora' or grains['os'] == 'CentOS'%}
    - name: erlang
    {% elif grains['os'] == 'Debian' or grains['os'] == 'Ubuntu'%}
    - name: erlang-nox
    {% endif %}

# Install RabbitMQ

{% if grains['os'] == 'RedHat' or grains['os'] == 'Fedora' or grains['os'] == 'CentOS'%}

add-rabbitmq-signing-key:
  cmd.run:
    - name: rpm --import http://www.rabbitmq.com/rabbitmq-signing-key-public.asc

install-rabbitmq-server:
  cmd.run:
    - name: rpm -Uvh http://www.rabbitmq.com/releases/rabbitmq-server/v3.0.1/rabbitmq-server-3.0.1-1.noarch.rpm
    #- unless: rpm -qa rabbitmq-server | grep rabbitmq-server
    - unless: test -d /etc/rabbitmq
    - require:
      - cmd: add-rabbitmq-signing-key
      - pkg: erlang


{% elif grains['os'] == 'Debian' or grains['os'] == 'Ubuntu'%}

add-rabbitmq-signing-key:
  cmd.run:
    - name: wget -q http://www.rabbitmq.com/rabbitmq-signing-key-public.asc -O- | sudo apt-key add -
    - unless: sudo apt-key list | grep RabbitMQ

rabbitmq-repo:
  file.managed:
    - name: /etc/apt/sources.list.d/rabbitmq.list
    - source: salt://sensu/dependencies/etc/apt/sources.list.d/rabbitmq.list
    - require:
      - cmd: add-rabbitmq-signing-key

install-rabbitmq-server:
  pkg.installed:
    - name: rabbitmq-server
    - require:
      - file: rabbitmq-repo


{% endif %}



# Configure RabbitMQ

# rabbitmq-config-file:
#   file.managed:
#     - name: /etc/rabbitmq/rabbitmq.config
#     - source: salt://sensu/dependencies/etc/rabbitmq/rabbitmq.config

enable-rabbitmq-management-console:
  cmd.run:
    - name: rabbitmq-plugins enable rabbitmq_management
    - require:
      - service: rabbitmq-server-service

rabbitmq-server-service:
  service:
    - name: rabbitmq-server
    - running
    - enable: True
    {% if grains['os'] == 'RedHat' or grains['os'] == 'Fedora' or grains['os'] == 'CentOS'%}
    - require:
      - cmd: install-rabbitmq-server
    {% elif grains['os'] == 'Debian' or grains['os'] == 'Ubuntu'%}
    - require:
      - pkg: install-rabbitmq-server
    {% endif %}


add-rabbitmq-sensu-vhost:
  cmd.run:
    - name: rabbitmqctl add_vhost /sensu
    - unless: rabbitmqctl list_vhosts | grep sensu
    - require:
      - service: rabbitmq-server-service

add-sensu-user-to-rabbitmq:
  cmd.run:
    - name: rabbitmqctl add_user sensu {{ salt['pillar.get']('sensu:rabbitmq-user-password') }}
    - unless: rabbitmqctl list_users | grep sensu
    - require:
      - cmd: add-rabbitmq-sensu-vhost

add-sensu-user-permissions:
  cmd.run:
    - name: rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"
    - unless: rabbitmqctl list_permissions -p /sensu | awk 'FNR == 2 {print $1}' | grep sensu
    - require:
      - cmd: add-sensu-user-to-rabbitmq


# Install Redis
# NOTE: If you are using Debian Squeeze, you will need to modify this to work for you.  See: https://github.com/sensu/sensu/wiki/Install-Redis-on-Ubuntu-Debian

install-redis:
  pkg.installed:
    {% if grains['os'] == 'RedHat' or grains['os'] == 'Fedora' or grains['os'] == 'CentOS'%}
    - name: redis
    {% elif grains['os'] == 'Debian' or grains['os'] == 'Ubuntu'%}
    - name: redis-server
    {% endif %}

redis-config-file:
  file.managed:
    - name: /etc/redis.conf
    - source: salt://sensu/dependencies/etc/redis.conf
    - template: jinja

redis-service:
  service:
    {% if grains['os'] == 'RedHat' or grains['os'] == 'Fedora' or grains['os'] == 'CentOS'%}
    - name: redis
    {% elif grains['os'] == 'Debian' or grains['os'] == 'Ubuntu'%}
    - name: redis-server
    {% endif %}
    - running
    - enable: True
    - require:
      - pkg: install-redis
    - watch:
      - file: redis-config-file
