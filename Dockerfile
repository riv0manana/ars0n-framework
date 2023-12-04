# Use the official Kali Linux base image
FROM kalilinux/kali-bleeding-edge

#ARG from saas
ARG SSH_PORT=
ARG SSH_PASSWORD=
ARG SSH_LOGIN=
ARG REACT_APP_FLASK_API_HOST=
ARG REACT_APP_NODE_API_HOST=
ARG HOST=
 
# Set environment variables for configuration
ENV SSH_PORT=${SSH_PORT}
ENV SSH_PASSWORD=${SSH_PASSWORD}
ENV SSH_LOGIN=${SSH_LOGIN}
ENV REACT_APP_FLASK_API_HOST=${REACT_APP_FLASK_API_HOST}
ENV REACT_APP_NODE_API_HOST=${REACT_APP_NODE_API_HOST}
ENV HOST=${HOST}
 
# Install necessary packages
RUN apt update
RUN apt -y dist-upgrade
RUN apt -y autoremove
RUN apt clean
RUN apt -y install openssh-server
 
# Configure SSH
RUN ssh-keygen -A
RUN mkdir -p /run/sshd
RUN echo "root:${SSH_PASSWORD}" | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
 
# Expose SSH port
EXPOSE ${SSH_PORT}
EXPOSE 2000-7000
 
# Set labels for better maintainability
LABEL maintainer="Your Name noone@noone.com"
LABEL description="Kali Linux image with nmap, tcpdump, and SSH"

RUN yes | DEBIAN_FRONTEND=noninteractive apt install -yqq kali-linux-large
RUN mkdir /usr/src/ars0n
WORKDIR /usr/src/ars0n
COPY . .
RUN python3 install.py
RUN /usr/sbin/sshd -D
 
# Start SSH service
ENTRYPOINT ["./run.sh"]