FROM centos:centos7
MAINTAINER email: akumor@users.noreply.github.com 

# Announce the initiation of the Dockerfile
RUN echo 'Starting docker-puppetexplorer Dockerfile execution...'

# Add the puppetexplorer RPM
ADD ./puppetexplorer-2.0.0-1.noarch.rpm /root/

# Run updates and install some basic necessary packages
RUN yum -y localinstall /root/puppetexplorer-2.0.0-1.noarch.rpm && \
    yum -y --setopt=tsflags=nodocs update && \
    yum -y --setopt=tsflags=nodocs install httpd && \
    yum clean all

RUN cp -R /usr/share/puppetexplorer/* /var/www/html/ && mv /var/www/html/config.js.example /var/www/html/config.js

EXPOSE 80

# Simple startup script to avoid some issues observed with container restart
ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

# Run the deployment script when container starts
CMD [ "/run-httpd.sh" ]
