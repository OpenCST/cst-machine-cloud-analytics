# Apache Load Balancer w/TLS and Let's Encrypt

FROM httpd:2.4-alpine
MAINTAINER Antonio Anzivino (antonio.anzivino@csttech.it)

# Clean up Apache configuration and use from this project
# Stuff is commented in configuration file
WORKDIR /usr/local/apache2
RUN rm -rf conf/*.conf conf/extra conf/original
COPY *.conf conf/

# SSL configuration
ENV APACHE_SSL_ROOT=/etc/ssl/private/
ENV APACHE_SSL_CERTS=analytics.csttech.it.crt
ENV APACHE_SSL_PRIVATE=analytics.csttech.it.key
ENV APACHE_SSL_CA_BUNDLE=analytics.csttech.it.ca_bundle
ENV APACHE_SERVER_NAME=analytics.csttech.it
ENV APACHE_SERVER_ADMIN=servizi@csttech.it


# Htdocs volume
VOLUME /usr/local/apache2/htdocs/

#The ports
EXPOSE 80
EXPOSE 443
