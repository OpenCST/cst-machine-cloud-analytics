#!/bin/sh

export DOCKER_SSL_DIRECTORY=/home/docker/ssl
export DOCKER_SSL_PRIVATE=$DOCKER_SSL_DIRECTORY/csttech.it.key
export DOCKER_SSL_CERTIFICATE=$DOCKER_SSL_DIRECTORY/csttech.it.crt
export DOCKER_SSL_CA=$DOCKER_SSL_DIRECTORY/csttech.it.ca_bundle
