prereqs:
  pkg.installed:
    - names:
      - git
      - gcc
      - erlang
      - erlang-dev

erica:
  git.latest:
    - name: git://github.com/benoitc/erica.git
    - target: /tmp/erica

compile_erica:
  cmd.run:
    - name: "export HOME=/root; make && make install"
    - cwd: /tmp/erica
    - env: HOME=/root
    - watch:
      - git: erica
    - require:
      - file: /usr/bin/rebar
      - pkg: prereqs

/usr/bin/rebar:
  file.managed:
    - source: salt://erica/usr/bin/rebar
    - mode: 777
