#!/bin/bash
rm -rf ./crypto-config/ordererOrganizations
rm -rf ./crypto-config/peerOrganizations
rm -rf ./channel-artifacts/*.block
rm -rf ./channel-artifacts/*.tx
git status
docker network list
docker volume list
