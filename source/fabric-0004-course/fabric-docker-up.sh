#!/bin/bash
echo
echo "##########################################################"
echo "##### Docker container start up ##########################"
echo "##########################################################"
docker-compose -f docker-compose.yaml -f docker-compose-couch.yaml up -d
