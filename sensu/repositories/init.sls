#
# Sensu Repository
#

{% if grains['os'] == 'Debian' or grains['os'] == 'Ubuntu'%}
install-sensu-apt-key:
  cmd.run:
    - name: wget -q http://repos.sensuapp.org/apt/pubkey.gpg -O- | sudo apt-key add -
    - unless: sudo apt-key list | grep Sonian
{% endif %}

sensu-repo:
  file.managed:
    {% if grains['os'] == 'RedHat' or grains['os'] == 'Fedora' or grains['os'] == 'CentOS'%}
    - name: /etc/yum.repos.d/sensu.repo
    - source: salt://sensu/repositories/etc/yum.repos.d/sensu.repo
    {% elif grains['os'] == 'Debian' or grains['os'] == 'Ubuntu'%}
    - name: /etc/apt/sources.list.d/sensu.list
    - source: salt://sensu/repositories/etc/apt/sources.list.d/sensu.list
    - require:
      - cmd: install-sensu-apt-key
    {% endif %}
