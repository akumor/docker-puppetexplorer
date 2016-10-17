#!/bin/bash

# Update the Apache configuration file with the PUPPET_SERVER
# environment variable
sed -i "s/\${PUPPET_SERVER}/${PUPPET_SERVER}/g" /etc/httpd/conf/httpd.conf

# Make sure we're not confused by old, incompletely-shutdown httpd
# context after restarting the container.  httpd won't start correctly
# if it thinks it is already running.
rm -rf /run/httpd/* /tmp/httpd*

exec /usr/sbin/apachectl -DFOREGROUND
