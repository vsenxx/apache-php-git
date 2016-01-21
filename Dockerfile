FROM php:5.6-apache
RUN apt-get update && apt-get install -y git
VOLUME ["/etc/apache2","/var/html"]
EXPOSE 80
EXPOSE 88
EXPOSE 443