#!/bin/bash
echo
echo "##########################################################"
echo "##### Generate certificates using cryptogen tool #########"
echo "##########################################################"
cryptogen generate --config=./crypto-config.yaml
echo "##########################################################"
echo "##### Copy channel crypto ordererOrganizations ###########"
echo "##########################################################"
cp -r ../crypto-config/ordererOrganizations ./crypto-config/
