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
rm -rf ../channel-artifacts/*.json
rm -rf ../channel-artifacts/*.pb

#echo
#echo "##########################################################"
#echo "##### Clean application cpp ##############################"
#echo "##########################################################"
#rm -rf ./application/connection-org*.json
#rm -rf ./application/connection-org*.yaml
#rm -rf ./application/*/*/wallet/*
#
#echo
#echo "##########################################################"
#echo "##### Clean docker environment ###########################"
#echo "##########################################################"
#docker rm -f $(docker ps -aq)
#docker rmi -f $(docker images | grep fabcar | awk '{print $3}')
#docker network prune
#docker volume prune
#
#echo
#echo "##########################################################"
#echo "##### Docker container running instances #################"
#echo "##########################################################"
#docker ps -a
#
#echo
#echo "##########################################################"
#echo "##### Docker container currently existing network ########"
#echo "##########################################################"
#docker network list
#
#echo
#echo "##########################################################"
#echo "##### Docker container currently existing volume #########"
#echo "##########################################################"
#docker volume list
#
#echo
#echo "##########################################################"
#echo "##### Git branch status ##################################"
#echo "##########################################################"
#git br
#git st
