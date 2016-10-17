FROM centos:centos7
MAINTAINER email: akumor@users.noreply.github.com 

# Announce the initiation of the Dockerfile
RUN echo 'Starting docker-puppetexplorer Dockerfile execution...'

# Add the puppetexplorer RPM
ADD ./puppetexplorer-2.0.0-1.noarch.rpm /root/

# Run updates and install some basic necessary packages
RUN yum -y localinstall /root/puppetexplorer-2.0.0-1.noarch.rpm && \
    yum -y --setopt=tsflags=nodocs update && \
    yum -y --setopt=tsflags=nodocs install httpd mod_ssl && \
    yum clean all

RUN cp -R /usr/share/puppetexplorer/* /var/www/html/ && mv /var/www/html/config.js.example /var/www/html/config.js

RUN echo 'SSLProxyEngine On' >> /etc/httpd/conf/httpd.conf && \
    echo 'RequestHeader set Front-End-Https "On"' >> /etc/httpd/conf/httpd.conf && \
    echo 'RequestHeader set Access-Control-Expose-Headers "X-Records"' >> /etc/httpd/conf/httpd.conf && \
    echo 'RequestHeader set Access-Control-Allow-Origin "On"' >> /etc/httpd/conf/httpd.conf && \
    echo 'ProxyPass /api https://${PUPPET_SERVER}:8081/' >> /etc/httpd/conf/httpd.conf && \
    echo 'ProxyPassReverse /api https://${PUPPET_SERVER}:8081/' >> /etc/httpd/conf/httpd.conf

EXPOSE 80

# Simple startup script to avoid some issues observed with container restart
ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

# Run the deployment script when container starts
CMD [ "/run-httpd.sh" ]
