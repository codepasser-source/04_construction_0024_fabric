#!/bin/bash
echo
echo "##########################################################"
echo "##### Docker container shutdown ##########################"
echo "##########################################################"
docker-compose -f docker-compose.yaml -f docker-compose-couch.yaml -f docker-compose-etcdraft.yaml down
