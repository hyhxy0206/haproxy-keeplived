/etc/rsyslog.conf:
  file.managed:
   - source: salt://modules/cluster/haproxy/files/rsyslog.conf

rsyslog-stop-service:
  service.dead:
    - name: rsyslog.service

rsyslog-start-service:
  service.running:
    - name: rsyslog.service
    - enable: true

