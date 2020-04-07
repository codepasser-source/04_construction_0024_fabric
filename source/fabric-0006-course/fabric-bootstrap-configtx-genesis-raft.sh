#!/bin/bash
echo "##########################################################"
echo "#####  Generating Orderer Genesis block [Raft] ###########"
echo "##########################################################"
configtxgen -profile SampleMultiNodeEtcdRaft -channelID course-sys-channel -outputBlock ./channel-artifacts/genesis.block
