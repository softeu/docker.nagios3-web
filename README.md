docker.ubuntu-apache-php-postgres_client
========================================

Docker image - ubuntu with apache and nagios3 cgi - web interface for nagios

usage:
 docker build -t="softeu/nagios3-web"" .

 docker run -p --name nagios-web --volumes-from=nagios -e NAGIOSADMIN_USER=nagiosadmin -e NAGIOSADMIN_PASS=pass softeu/nagios3-web
