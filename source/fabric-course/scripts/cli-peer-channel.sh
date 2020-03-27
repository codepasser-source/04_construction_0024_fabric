#!/bin/bash
echoEnvironment(){
  echo "# CLI container environment variables for Current"
  echo $CORE_PEER_ADDRESS
  echo $CORE_PEER_LOCALMSPID
  echo $CORE_PEER_TLS_CERT_FILE
  echo $CORE_PEER_TLS_KEY_FILE
  echo $CORE_PEER_TLS_ROOTCERT_FILE
  echo $CORE_PEER_MSPCONFIGPATH
  echo $CHANNEL_NAME
}

echo "#################################################################"
echo "#######    Channel create orderer.example.com:7050    ###########"
echo "#################################################################"
export CHANNEL_NAME=fabric-course
# the channel.tx file is mounted in the channel-artifacts directory within your CLI container
# as a result, we pass the full path for the file
# we also pass the path for the orderer ca-cert in order to verify the TLS handshake
# be sure to export or replace the $CHANNEL_NAME variable appropriately
echoEnvironment()
#peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

echo "#################################################################"
echo "#######    Channel join peer0.org1.example.com:7051   ###########"
echo "#################################################################"
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
export CORE_PEER_LOCALMSPID=Org1MSP
#export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
#export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
echo "CLI container environment variables for peer0.org1.example.com:7051"
echoEnvironment()
#peer channel join -b $CHANNEL_NAME.block

echo "#################################################################"
echo "#######    Channel join peer0.org2.example.com:9051    ##########"
echo "#################################################################"
export CORE_PEER_ADDRESS=peer0.org2.example.com:9051
export CORE_PEER_LOCALMSPID=Org2MSP
#export CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.crt
#export CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
echo "CLI container environment variables for peer0.org2.example.com:7051"
echoEnvironment()
#peer channel join -b $CHANNEL_NAME.block
