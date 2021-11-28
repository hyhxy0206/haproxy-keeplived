include:
  - modules.cluster.haproxy.install
  - modules.cluster.keepalived.install

haproxy-master-conf-keepalived:
  file.managed:
    - name: /etc/keepalived/keepalived.conf
    - source: salt://modules/cluster/haproxy/files/master.conf.j2
    - template: jinja

/scripts/check_haproxy.sh:
  file.managed:
    - source: salt://modules/cluster/haproxy/files/check_haproxy.sh
    - mode: '0755'

haproxy-master-service-keepalived:
  service.running:
    - name: keepalived.service
    - enable: true
    - reload: true
    - watch:
      - file: haproxy-master-conf-keepalived
