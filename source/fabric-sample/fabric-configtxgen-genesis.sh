#!/bin/bash
rm -rf ./channel-artifacts/genesis.block
configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block -channelID course-channel
