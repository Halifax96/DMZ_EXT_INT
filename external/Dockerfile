FROM ubuntu:24.04 
RUN apt-get update && apt-get install -y apache2 openssh-server net-tools nmap iputils-ping traceroute nano iptables pkg-config 
RUN apt-get update && apt-get install -y tcpdump
RUN echo 'root:root' |chpasswd 
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config 
RUN mkdir /var/run/sshd
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EXPOSE 22 
EXPOSE 80
EXPOSE 443
COPY ./start.sh . 
RUN chmod +x start.sh 
CMD ["./start.sh"]