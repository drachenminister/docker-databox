FROM phusion/baseimage:0.10.0

# install required packages
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install -y --no-install-recommends \
    bash-completion \
    htop \
    tzdata \
    vsftpd \
    db-util \
    poppler-utils \
    default-jre-headless 


# set Timezone to Europe/Vienna
ENV TZ=Europe/Vienna
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# add custom binaries
ADD bin/* /usr/bin/

#add PortableSigner
Add PortableSigner /opt/PortableSigner
RUN ln -s /opt/PortableSigner/PortableSigner.sh /usr/bin/PortableSigner

#add certificates
ADD certs/*.pfx /persist/certs/

#make directories
RUN mkdir -p /persist/tmp/ /persist/skipped /persist/inbox/Ablage

# add configuration files
ADD etc/vsftpd.conf /etc/vsftpd/
ADD etc/vsftpd.pem /etc/vsftpd/
ADD etc/vsftpd /etc/pam.d/
ADD etc/payroll /etc/cron.d/

# adding services
RUN mkdir -p /etc/service/vsftpd /etc/my_init.d
ADD service/vsftpd.sh /etc/service/vsftpd/run 
RUN chmod +x /etc/service/vsftpd/run /etc/my_init.d/*

# create /empty to make vsftpd happy
RUN mkdir -p /empty

# create special user with default password
ADD users.txt /persist/
RUN ftpuser -a inbox -p inbox
RUN chown ftp:ftp /persist/inbox

VOLUME /persist
CMD ["/sbin/my_init"]
