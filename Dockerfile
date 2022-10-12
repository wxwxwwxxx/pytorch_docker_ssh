FROM 4c14b66a4c09
RUN apt update && apt install -y ssh
RUN echo "root:123456"|chpasswd
RUN mkdir -vp /run/sshd
COPY sshd_config /etc/ssh/
COPY .bashrc /root/
#COPY start_ssh.sh /opt/nvidia/entrypoint.d
#RUN chmod 755 /usr/local/bin/nvidia_entrypoint.sh
