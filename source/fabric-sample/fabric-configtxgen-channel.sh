#!/bin/bash
rm -rf ./channel-artifacts/channel.tx
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID course-channel
