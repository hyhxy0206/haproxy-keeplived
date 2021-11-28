#!/bin/bash
VIP=$2
sendmail (){
        subject="${VIP}'s server keepalived state is translate"
        content="`date +'%F %T'`: `hostname`'s state change to master"
        echo $content | mail -s "$subject" 1470044516@qq.com
}
case "$1" in
  master)
        haproxy_status=$(ps -ef|grep -Ev "grep|$0"|grep '\bhaproxy\b'|wc -l)
        if [ $haproxy_status -lt 1 ];then
            systemctl start haproxy
        fi
        sendmail
  ;;
  backup)
        haproxy_status=$(ps -ef|grep -Ev "grep|$0"|grep '\bhaproxy\b'|wc -l)
        if [ $haproxy_status -gt 0 ];then
            systemctl stop haproxy
        fi
  ;;
  *)
        echo "Usage:$0 master|backup"
  ;;
esac
