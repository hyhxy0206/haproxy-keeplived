include:
  - modules.cluster.keepalived.install

backup-conf-keepalived:
  file.managed:
    - name: /etc/keepalived/keepalived.conf
    - source: salt://modules/cluster/keepalived/files/backup.conf.j2
    - template: jinja

backup-service-keepalived:
  service.running:
    - name: keepalived.service
    - enable: true
    - reload: true
    - watch:
      - file: backup-conf-keepalived
