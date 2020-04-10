#!/bin/bash
echo "#################################################################"
echo "### Change channel configuration transaction 'channel.tx' org3 ##"
echo "#################################################################"
export FABRIC_CFG_PATH=$PWD && configtxgen -printOrg Org3MSP > ../channel-artifacts/org3.json

echo "#################################################################"
echo "### Copy channel crypto ordererOrganizations ####################"
echo "#################################################################"
cp -r ../crypto-config/ordererOrganizations ./crypto-config/
