#!/bin/bash
echo
echo "##########################################################"
echo "##### Docker container shutdown ##########################"
echo "##########################################################"
# Exclude CA
docker-compose -f docker-compose.yaml -f docker-compose-couch.yaml down
# Include CA
#docker-compose -f docker-compose.yaml -f docker-compose-couch.yaml -f docker-compose-kafka.yaml -f docker-compose-ca.yaml down
