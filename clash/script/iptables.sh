#!/bin/bash
ip rule add fwmark 1 table 100
ip route add local default dev lo table 100
iptables -t mangle -N clash
iptables -t mangle -A clash -d 0.0.0.0/8 -j RETURN
iptables -t mangle -A clash -d 10.0.0.0/8 -j RETURN
iptables -t mangle -A clash -d 127.0.0.0/8 -j RETURN
iptables -t mangle -A clash -d 169.254.0.0/16 -j RETURN
iptables -t mangle -A clash -d 172.16.0.0/12 -j RETURN
iptables -t mangle -A clash -d 192.168.0.0/16 -j RETURN
iptables -t mangle -A clash -d 224.0.0.0/4 -j RETURN
iptables -t mangle -A clash -d 240.0.0.0/4 -j RETURN
# FORWARD ALL
iptables -t mangle -A clash -p tcp -j TPROXY --on-port 7893 --tproxy-mark 1
iptables -t mangle -A clash -p udp -j TPROXY --on-port 7893 --tproxy-mark 1
# REDIRECT
iptables -t mangle -A clash -p tcp -j RETURN -m mark --mark 1
iptables -t mangle -A clash -p udp -j RETURN -m mark --mark 1

iptables -t mangle -A PREROUTING -p tcp -j clash
iptables -t mangle -A PREROUTING -p udp -j clash
echo "执行路由表完毕"
