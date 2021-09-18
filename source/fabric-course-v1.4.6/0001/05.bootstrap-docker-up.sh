#!/bin/bash
echo
echo "##########################################################"
echo "##### Docker compose up container service  ###############"
echo "##########################################################"
COMPOSE_FILE=docker-compose-cli.yaml
echo "Script variable : COMPOSE_FILE = " ${COMPOSE_FILE}

docker-compose -f ${COMPOSE_FILES} up -d
