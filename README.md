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

## Variabili di ambiente globali al sistema

Variabili sempre disponibili

- `DOCKER_SSL_DIRECTORY`: directory dei certificati SSL
- `DOCKER_SSL_PRIVATE`: chiave privata SSL (deve essere letta solo da Docker)
- `DOCKER_SSL_CERTIFICATE`: certificato SSL
- `DOCKER_SSL_CA`: certificato CA SSL

## Configurazioni Docker particolari

- Rete di load balancing

      docker network create -d bridge --subnet=192.168.168.0/24 docker-apache

## Certificati openssl

Vanno preinstallati sulla macchina in `/home/docker/ssl`

- `csttech.it.key` chiave privata, con chmod 600
- `csttech.it.crt` certificato
- `csttech.it.ca_bundle` certificato CA

# Configurazione Gradle

Gradle si basa su un file di properties ignorato. La prima volta che si scarica il progetto, come da avviso,
è necessario lanciare il task

    ./gradlew generateProperties
    
Modificare quindi il file `gradle-local.properties` con le configurazioni custom della macchina

## httpd2 (installato su host)

**Nota**: lo stiamo facendo partire come macchina Docker

Il pacchetto va installato in locale usando apt-get.
Le configurazioni sono invece committate in questo repository sotto `src/main/resources/httpd2`

Di seguito i comandi per riavviare Apache con le nuove configurazioni 

    rm -f /etc/apache2/conf.d
    mkdir -p /etc/apache2/conf.d
    cp -R src/main/resources/httpd2/conf.d/* /etc/apache2/conf.d
    systemctl reload apache2


## Matomo server

## Sentry server
