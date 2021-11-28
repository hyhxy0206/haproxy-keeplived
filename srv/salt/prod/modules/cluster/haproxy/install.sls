include:
  - modules.cluster.haproxy.rsyslog

dep-haproxy-pkg:
  pkg.installed:
    - pkgs:
      - make
      - gcc
      - pcre-devel
      - bzip2-devel
      - openssl-devel
      - systemd-devel
      - gcc-c++

haproxy:
  user.present:
    - system: true
    - createhome: false
    - shell: /sbin/nologin

unzip-haproxy:
  archive.extracted:
    - name: /usr/src
    - source: salt://modules/cluster/haproxy/files/haproxy-{{ pillar['haproxy_version'] }}.tar.gz
    - if_missing: /usr/src/haproxy-{{ pillar['haproxy_version'] }}

salt://modules/cluster/haproxy/files/install.sh.j2:
  cmd.script:
    - template: jinja
    - unless: test -d {{ pillar['haproxy_install_dir'] }}
    - require:
      - pkg: dep-haproxy-pkg
      - archive: unzip-haproxy

/usr/sbin/haproxy:
  file.symlink:
    - target: {{ pillar['haproxy_install_dir'] }}/sbin/haproxy
    - require:
      - cmd: salt://modules/cluster/haproxy/files/install.sh.j2

/etc/sysctl.conf:
  file.append:
    - text:
      - net.ipv4.ip_nonlocal_bind = 1
      - net.ipv4.ip_forward = 1
  cmd.run:
    - name: sysctl -p

{{ pillar['haproxy_install_dir'] }}/conf:
  file.directory:
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: true
    - require:
      - cmd: salt://modules/cluster/haproxy/files/install.sh.j2

{{ pillar['haproxy_install_dir'] }}/conf/haproxy.cfg:
  file.managed:
    - source: salt://modules/cluster/haproxy/files/haproxy.cfg.j2
    - template: jinja
    - require:
      - cmd: salt://modules/cluster/haproxy/files/install.sh.j2

/usr/lib/systemd/system/haproxy.service:
  file.managed:
    - source: salt://modules/cluster/haproxy/files/haproxy.service.j2
    - template: jinja

haproxy.service:
  service.running:
    - enable: true
    - reload: true
    - watch:
      - file: {{ pillar['haproxy_install_dir'] }}/conf/haproxy.cfg
/scripts:
  file.directory:
    - makedirs: ture
