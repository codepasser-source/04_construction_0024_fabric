#!/bin/bash
echo
echo "##########################################################"
echo "##### Docker container start up ##########################"
echo "##########################################################"
# Exclude CA
#docker-compose -f docker-compose.yaml -f docker-compose-couch.yaml -f docker-compose-etcdraft.yaml up -d
# Include CA
export COURSE_CA1_PRIVATE_KEY=$(cd crypto-config/peerOrganizations/org1.example.com/ca && ls *_sk)
export COURSE_CA2_PRIVATE_KEY=$(cd crypto-config/peerOrganizations/org2.example.com/ca && ls *_sk)
echo "========== COURSE_CA1_PRIVATE_KEY: $COURSE_CA1_PRIVATE_KEY =========="
echo "========== COURSE_CA2_PRIVATE_KEY: $COURSE_CA2_PRIVATE_KEY =========="
docker-compose -f docker-compose.yaml -f docker-compose-couch.yaml -f docker-compose-etcdraft.yaml -f docker-compose-ca.yaml up -d
