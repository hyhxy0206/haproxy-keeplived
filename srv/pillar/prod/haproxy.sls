haproxy_install_dir: /usr/local/haproxy
haproxy_version: 2.5.0
nodes:
  - web01 192.168.143.102:80
  - web02 192.168.143.103:80
  - web03 192.168.143.104:80

haproxy_pass: YFShqy8h
haproxy_vip: 192.168.143.250
haproxy_port: 80
haproxy_info:
  - 192.168.143.103
  - 192.168.143.104
