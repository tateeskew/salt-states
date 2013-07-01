{% if grains['os_family'] == 'RedHat'%}
graphite-dependencies:
  pkg.installed:
    - names:
      - pycairo
      - mod_python 
      - Django 
      - python-ldap 
      - python-memcached
      - python-sqlite2  
      - bitmap 
      - bitmap-console-fonts
      - bitmap-fixed-fonts
      - bitmap-fonts-compat
      - python-devel 
      - python-crypto 
      - pyOpenSSL 
      - gcc 
      - python-zope-filesystem 
      - python-zope-interface 
      - git 
      - gcc-c++ 
      - zlib-static 
      - mod_wsgi 
      - python-pip
{% endif %}
  
graphite-pip-dependencies:
  pip.installed:
    - names:
      - django-tagging
      - twisted
      - txamqp
    - require:
      - pkg: graphite-dependencies
