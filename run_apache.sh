#!/bin/bash


if [ ! -f /etc/nagios3/htpasswd.users ] ; then
  htpasswd -c -b -s /etc/nagios3/htpasswd.users ${NAGIOSADMIN_USER} ${NAGIOSADMIN_PASS}
  chown -R www-data:www-data /etc/nagios3/htpasswd.users
fi


set |grep '_PORT_' |tr  '=' ' ' |sed 's/^/SetEnv /' > /etc/apache2/conf-enabled/docker-vars.conf
set |grep '_ENV_' |tr  '=' ' ' |sed 's/^/SetEnv /' >> /etc/apache2/conf-enabled/docker-vars.conf

echo "export SERVER_NAME=$SERVER_NAME" >> /etc/apache2/envvars

echo "ServerName $SERVER_NAME" > /etc/apache2/conf-enabled/servername.conf

/etc/init.d/apache2 start && \
 tail -F /var/log/apache2/*log
