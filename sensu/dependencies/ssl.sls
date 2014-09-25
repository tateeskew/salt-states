# If you would like to use SSL with sensu and RabbitMQ you will
# want to create a pillar named 'use-ssl' and set it to True.  This state
# will read that pillar data and run the necessary states.  You will also wante
# to modify the script located at: sensu/dependencies/tmp/sensuinstall/ssl_certs.sh
# Make the necessary changes for your environment.
# - Tate Eskew

{% if salt['pillar.get']('sensu:use-ssl', false)  == true %}

include:
  - sensu.dependencies

# Use SSL for Sensu/RabbitMQ

generate-sslcert-script:
  file.managed:
    - name: /tmp/sensuinstall/ssl_certs.sh
    - source: salt://sensu/dependencies/tmp/sensuinstall/ssl_certs.sh

opensslcnf-file:
  file.managed:
    - name: /tmp/sensuinstall/openssl.cnf
    - source: salt://sensu/dependencies/tmp/sensuinstall/openssl.cnf

clean-sslcerts:
  cmd.run:
    - name: bash ssl_certs.sh clean
    - cwd: /tmp/sensuinstall
    - unless: test -e /tmp/sensuinstall/server_key.pem
    - require:
      - file: generate-sslcert-script
      - file: opensslcnf-file

generate-sslcerts:
  cmd.run:
    - name: bash ssl_certs.sh generate
    - cwd: /tmp/sensuinstall
    - unless: test -e /tmp/sensuinstall/server_key.pem
    - require:
      - file: generate-sslcert-script
      - file: opensslcnf-file
      - cmd: clean-sslcerts

copy-sslcerts:
  cmd.run:
    - name: bash ssl_certs.sh copy_rabbitmq
    - cwd: /tmp/sensuinstall
    - unless: test -e /etc/rabbitmq/ssl/server_key.pem
    - require:
      - cmd: generate-sslcerts
      - cmd: install-rabbitmq-server

{% endif %}
