#!/bin/bash
echo "#################################################################"
echo "#######    Generating anchor peer update for Org1MSP   ##########"
echo "#################################################################"

# Channel create & join & update anchors
docker exec cli ./scripts/cli-peer-channel.sh

# Chaincode install & instantiate
docker exec cli ./scripts/cli-peer-chaincode.sh
