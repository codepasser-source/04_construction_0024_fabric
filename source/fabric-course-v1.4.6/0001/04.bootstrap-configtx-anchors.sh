#!/bin/bash
echo "#################################################################"
echo "#######    Generating anchor peer update     ####################"
echo "#################################################################"
CHANNEL_NAME="mychannel"
echo "Script variable : CHANNEL_NAME = " $CHANNEL_NAME

# Org1 锚点定义
echo "#################################################################"
echo "#######    Generating anchor peer update for Org1MSP   ##########"
echo "#################################################################"
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP

# Org2 锚点定义
echo
echo "#################################################################"
echo "#######    Generating anchor peer update for Org2MSP   ##########"
echo "#################################################################"
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP
