# Macchina CST Cloud analytics.csttech.it

Readme dei prodotti installati e configurabili.
Questo readme si compone della sezione di installazione e configurazione della macchina, resa più possibile ripetibile a piacimento.
Successivamente sono elencate le configurazioni versionate e i servizi Docker disponibili.

L'idea generale è che ogni servizio Docker debba essere un sotto-progetto Gradle da lanciare con Gradle e Docker Palantir Plugin.
Nel repository vanno documentate (**ma non pushate!!!**) le password e i certificati di cui le app hanno bisogno.
La configurazione dei segreti è a carico del Service su indicazione di DevOps.

# Setup della macchina

Di seguito tutta la procedura di installazione resa ripetibile

    [...]

## Configurazioni Docker particolari

- Rete di load balancing

      docker network create -d bridge --subnet=192.168.168.0/24 docker-apache

## Certificati openssl

Vanno preinstallati sulla macchina in `/etc/ssl/private/`

- `csttech.it.key` chiave privata
- `csttech.it.crt` certificato
- `csttech.it.ca_bundle` certificato CA

## httpd2 (installato su host)

Il pacchetto va installato in locale usando apt-get.
Le configurazioni sono invece committate in questo repository sotto `src/main/resources/httpd2`

Di seguito i comandi per riavviare Apache con le nuove configurazioni 

    rm -f /etc/apache2/conf.d
    mkdir -p /etc/apache2/conf.d
    cp -R src/main/resources/httpd2/conf.d/* /etc/apache2/conf.d
    systemctl reload apache2


## Matomo server

## Sentry server
