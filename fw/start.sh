#!/bin/bash 

# Workarround para solventar el error que aparece si en la definici´ on de la red ponemos como gateway 
#la IP de m´ aquina que queremos que ejerza como tal (en este caso, fw). No podemos poner IPs 
#repetidas en el fichero docker-compose.yml 

echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

iptables -A FORWARD -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -p udp -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -p icmp -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -A FORWARD  -p tcp  -s 10.5.2.0/24 -d 10.5.0.0/24 -j ACCEPT
iptables -A FORWARD  -p udp  -s 10.5.2.0/24 -d 10.5.0.0/24 -j ACCEPT
iptables -A FORWARD  -p icmp -s 10.5.2.0/24 -d 10.5.0.0/24 -j ACCEPT
iptables -t nat -A POSTROUTING -d 10.5.0.0/24 -s 10.5.2.0/24 -j SNAT --to 10.5.0.1

iptables -A FORWARD -p tcp -s 10.5.2.0/24 -d 10.5.1.0/24 --dport 80 -j ACCEPT
iptables -A FORWARD -p tcp -s 10.5.2.20 -d 10.5.1.0/24 --dport 22  -j ACCEPT

iptables -A INPUT -p tcp --dport 80 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT

/usr/sbin/sshd -D