#!/bin/bash
echo
echo "##########################################################"
echo "##### Docker compose down container service ##############"
echo "##########################################################"
docker-compose -f docker-compose-cli.yaml down --volumes --remove-orphans
