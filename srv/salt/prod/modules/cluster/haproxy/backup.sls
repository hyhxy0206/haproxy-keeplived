include:
  - modules.cluster.haproxy.install
  - modules.cluster.keepalived.install

haproxy-backup-conf-keepalived:
  file.managed:
    - name: /etc/keepalived/keepalived.conf
    - source: salt://modules/cluster/haproxy/files/backup.conf.j2
    - template: jinja

/scripts/notify.sh:
  file.managed:
    - source: salt://modules/cluster/haproxy/files/notify.sh
    - mode: '0755'

haproxy-backup-service-keepalived:
  service.running:
    - name: keepalived.service
    - enable: true
    - reload: true
    - watch:
      - file: haproxy-backup-conf-keepalived

haproxy-backup-service:
  service.dead:
    - name: haproxy.service
    - enable: flase

