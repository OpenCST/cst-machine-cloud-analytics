# Macchina CST Cloud analytics.csttech.it

Readme dei prodotti installati e configurabili.
Questo readme si compone della sezione di installazione e configurazione della macchina, resa più possibile ripetibile a piacimento.
Successivamente sono elencate le configurazioni versionate e i servizi Docker disponibili.

L'idea generale è che ogni servizio Docker debba essere un sotto-progetto Gradle da lanciare con Gradle e Docker Palantir Plugin.
Nel repository vanno documentate (**ma non pushate!!!**) le password e i certificati di cui le app hanno bisogno.
La configurazione dei segreti è a carico del Service su indicazione di DevOps.

# Setup della macchina

Di seguito tutta la procedura di installazione resa ripetibile

    sudo yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo

    sudo yum install -y yum-utils device-mapper-persistent-data lvm2 java java-1.8.0-openjdk-devel.x86_64 docker-ce docker-ce-cli containerd.io docker-compose git bridge-utils
 
    sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
    
    sudo useradd -g docker docker
    sudo passwd docker
     
    #### Disable IPV6
    sysctl -w net.ipv6.conf.all.disable_ipv6=1
    grub2-editenv - set "kernelopts=root=/dev/mapper/cl-root ro crashkernel=auto resume=/dev/mapper/cl-swap rd.lvm.lv=cl/root rd.lvm.lv=cl/swap rhgb quiet ipv6.disable=1"
     
     
    ## Abilita firewall per docker
     
    sysctl -w net.ipv4.conf.all.forwarding=1
    iptables -P FORWARD ACCEPT
    firewall-cmd --permanent --zone=trusted --change-interface=docker0
    firewall-cmd --reload 

 
(Comando promemoria da non lanciare per aprire la stocket di Docker)   
 
    ## firewall-cmd --permanent --zone=trusted --add-port 2375/tcp

Lanciare quindi `systemctl edit docker.service`

    [Service]
    ExecStart=
    ExecStart=/usr/bin/dockerd --containerd=/run/containerd/containerd.sock
    #User=docker
    #Group=docker

Modificare `/etc/docker/daemon.json`

    {
        "data-root": "/mnt/docker",
        "ipv6": false,
        "ip":"5.150.139.168",
        "ip-forward": true,
        "ip-masq": true,
        "hosts": ["fd://", "tcp://127.0.0.1:2375"],
        "userland-proxy": false,
        "selinux-enabled": true,
        "group": "docker"
    }


Lanciare da root per creare la datadir di Docker

    mkdir -p /mnt/docker
    chown docker:docker /mnt/docker
    chown -R docker:docker /etc/docker
    

Configurazione code completion (da root)

    sudo yum -y install bash-completion
    sudo curl -L https://raw.githubusercontent.com/docker/compose/master/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
    sudo curl -L https://raw.githubusercontent.com/docker/machine/v0.16.0/contrib/completion/bash/docker-machine.bash -o /etc/bash_completion.d/docker-machine
    sudo curl https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker -o /etc/bash_completion.d/docker.sh

Abilitare e lanciare Docker (da root)

    systemctl daemon-reload
    systemctl enable docker
    systemctl start docker

## Variabili di ambiente globali al sistema

Variabili sempre disponibili. Sono mappate in `src/main/resources/etc/profile.d/docker.sh`

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

## docker-apache2

Servizio Apache2 dockerizzato. Fare riferimento al [README](./docker-apache2/README.md)

## Matomo server

## Sentry server
