#!/bin/bash
echo "#################################################################"
echo "### Generating channel configuration transaction 'channel.tx' ###"
echo "#################################################################"
CHANNEL_NAME="mychannel"
echo "Script variable : CHANNEL_NAME = " $CHANNEL_NAME

configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME