#!/bin/bash
echo
echo "##########################################################"
echo "##### Clean crypto config ################################"
echo "##########################################################"
rm -rf ./crypto-config/ordererOrganizations
rm -rf ./crypto-config/peerOrganizations

echo
echo "##########################################################"
echo "##### Clean channel artifacts ############################"
echo "##########################################################"
rm -rf ./channel-artifacts/*.block
rm -rf ./channel-artifacts/*.tx

docker rm -f $(docker ps -aq)
docker rmi -f $(docker images | grep mycc | awk '{print $3}')
docker network prune
docker volume prune

echo
echo "##########################################################"
echo "##### Docker container running instances #################"
echo "##########################################################"
docker ps -a

echo
echo "##########################################################"
echo "##### Docker container currently existing network ########"
echo "##########################################################"
docker network list

echo
echo "##########################################################"
echo "##### Docker container currently existing volume #########"
echo "##########################################################"
docker volume list

echo
echo "##########################################################"
echo "##### Git branch status ##################################"
echo "##########################################################"
git br
git st
