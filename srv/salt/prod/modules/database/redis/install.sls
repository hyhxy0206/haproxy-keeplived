redis-pkg-install:
  pkg.installed:
    - pkgs:
      - gcc
      - gcc-c++
      - make
      - tcl-devel 
      - systemd-devel

redis-unzip:
  archive.extracted:
    - name: /usr/src
    - source: salt://modules/database/redis/files/redis-6.2.6.tar.gz
    - if_missing: /usr/src/redis-6.2.6

redis-install:
  cmd.script:
    - name: salt://modules/database/redis/files/install.sh.j2
    - unless: test -d {{ pillar['redis_install_dir'] }}
    - template: jinja
    - require:
      - archive: redis-unzip
      - pkg: redis-pkg-install

{{ pillar['redis_install_dir'] }}/conf:
  file.directory:
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: True
    - require:
      - cmd: redis-install

redis-conf:
  file.managed:
    - name: {{ pillar['redis_install_dir'] }}/conf/redis.conf
    - source: salt://modules/database/redis/files/redis.conf.j2
    - template: jinja
    - require:
      - cmd: redis-install

/usr/lib/systemd/system/redis_server.service:
  file.managed:
    - source: salt://modules/database/redis/files/redis_server.service.j2
    - template: jinja

redis_server.service:
  service.running:
    - enable: true
    - reload: true
    - watch:
      - file: redis-conf
