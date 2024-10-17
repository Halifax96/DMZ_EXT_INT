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

/usr/sbin/sshd -D