include:
  - modules.cluster.keepalived.install

master-conf-keepalived:
  file.managed:
    - name: /etc/keepalived/keepalived.conf
    - source: salt://modules/cluster/keepalived/files/master.conf.j2
    - template: jinja

master-service-keepalived:
  service.running:
    - name: keepalived.service
    - enable: true
    - reload: true
    - watch:
      - file: master-conf-keepalived
