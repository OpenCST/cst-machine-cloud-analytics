#Apache 2 load balancer / reverse proxy

Prevede l'uso di una network dedicata al load balancing. `docker-apache` deve essere creata prima
La configurazione è committata sotto le resources.

Funzioni del server: 1) http to https con hsts, 2) reverse proxy SSL

Il file `http-redirect.conf` fa la redirect secca su HTTPS

Il file `reverse-proxy.conf` configura i mapping con i server di back end. La strategia è quella del NameVirtualHost

## Prima di iniziare

Il file `gradle-local.properties` deve contenere la property `apache.sslRoot` che punti alla directory fisica coi certificati di CST.

Esempio: `/home/docker/ssl`, oppure `D:\\openssl\\csttech`

La network deve già esistere (vedi rete di load balancing).

## Avvio

Si può usare Gradle

`./gradlew docker-apache2:docker docker-apache2:dockerRun`

## Health check

Ad oggi nessuno

# Struttura del servizio

## Https redirect
Il seguente frammento usa `mod_rewrite` per reindirizzare qualsiasi chiamata http al medesimo URL in https

    NameVirtualHost *:80                                      # Host sulla 80 basato sui nomi
    <VirtualHost *:80>                                        #
       RewriteEngine On                                       # Accende il rewrite engine
       RewriteRule ^/(.*)$ https://%{HTTP_HOST}/$1 [R=301,L]  # Qualsiasi path in locale
                                                              #    Reindirizato in https
                                                              #    Sull'host di riferimento
                                                              #    Con redirect permanente
    </VirtualHost>                                            #

