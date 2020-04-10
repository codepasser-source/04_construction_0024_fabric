#!/bin/bash
echo_environment(){
  echo "# CLI container environment variables for Current"
  echo $CORE_PEER_ADDRESS
  echo $CORE_PEER_LOCALMSPID
  echo $CORE_PEER_TLS_CERT_FILE
  echo $CORE_PEER_TLS_KEY_FILE
  echo $CORE_PEER_TLS_ROOTCERT_FILE
  echo $CORE_PEER_MSPCONFIGPATH
  echo $CHANNEL_NAME
  echo $ORDERER_CA
}

echo "#################################################################"
echo "#######    Channel fetch orderer.example.com:7050    ############"
echo "#################################################################"
export CHANNEL_NAME=fabric-course
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
echo_environment
peer channel fetch config config_block.pb -o orderer.example.com:7050 -c $CHANNEL_NAME --tls --cafile $ORDERER_CA

configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config > config.json
jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"Org3MSP":.[1]}}}}}' config.json ./channel-artifacts/org3.json > modified_config.json
configtxlator proto_encode --input config.json --type common.Config --output config.pb
configtxlator proto_encode --input modified_config.json --type common.Config --output modified_config.pb
configtxlator compute_update --channel_id $CHANNEL_NAME --original config.pb --updated modified_config.pb --output org3_update.pb
configtxlator proto_decode --input org3_update.pb --type common.ConfigUpdate | jq . > org3_update.json
echo '{"payload":{"header":{"channel_header":{"channel_id":"'$CHANNEL_NAME'", "type":2}},"data":{"config_update":'$(cat org3_update.json)'}}}' | jq . > org3_update_in_envelope.json
configtxlator proto_encode --input org3_update_in_envelope.json --type common.Envelope --output org3_update_in_envelope.pb

mv config_block.pb ./channel-artifacts/
mv config.json ./channel-artifacts/
mv modified_config.json ./channel-artifacts/
mv config.pb ./channel-artifacts/
mv modified_config.pb ./channel-artifacts/
mv org3_update.pb ./channel-artifacts/
mv org3_update.json ./channel-artifacts/
mv org3_update_in_envelope.json ./channel-artifacts/
mv org3_update_in_envelope.pb ./channel-artifacts/

echo "#################################################################"
echo "#######    Channel signconfigtx peer0.org1.example.com:7051 #####"
echo "#################################################################"
peer channel signconfigtx -f org3_update_in_envelope.pb


echo "#################################################################"
echo "#######    Channel update peer0.org2.example.com:9051    ########"
echo "#################################################################"
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_ADDRESS=peer0.org2.example.com:9051
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
peer channel update -f org3_update_in_envelope.pb -c $CHANNEL_NAME -o orderer.example.com:7050 --tls --cafile $ORDERER_CA

