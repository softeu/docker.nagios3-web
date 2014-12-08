FROM softeu/ubuntu-base


RUN groupmod -g 1001 www-data && usermod -u 1001 www-data

RUN  apt-get install -y --no-install-recommends apache2 nagios3-cgi



RUN usermod -U www-data && chsh -s /bin/bash www-data

RUN echo 'ServerName ${SERVER_NAME}' >> /etc/apache2/conf-enabled/servername.conf

COPY enable-var-www-html-htaccess.conf /etc/apache2/conf-enabled/
COPY run_apache.sh /var/www/


RUN mkdir -p /opt/nagios /opt/nagios/var/ && ln -s /opt/nagios/var/objects.cache /var/cache/nagios3/objects.cache && ln -s /opt/nagios/var/status.dat /var/cache/nagios3/status.dat

RUN mv /etc/nagios3 /etc/nagios3- && ln -s /opt/nagios/etc /etc/nagios3  

RUN rm /etc/apache2/conf-available/nagios3.conf 
COPY apache2.conf /etc/apache2/conf-available/nagios3.conf


RUN mv /var/lib/nagios3 /var/lib/nagios3- && ln -s /opt/nagios/var /var/lib/nagios3
RUN mkdir -p /var/www/html/nagios/ && ln -s /etc/nagios3-/stylesheets /var/www/html/nagios/stylesheets && chown -R nagios  /etc/nagios3-/stylesheets && ln -s /etc/nagios3-/stylesheets /usr/share/nagios3/htdocs


ENV SERVER_NAME docker-apache


# for main web interface:
EXPOSE 80

WORKDIR /var/www/html

RUN echo '<?php Header("Location: /nagios3/"); ?>' > /var/www/html/index.php
RUN rm /var/www/html/index.html

CMD ["/var/www/run_apache.sh"]
