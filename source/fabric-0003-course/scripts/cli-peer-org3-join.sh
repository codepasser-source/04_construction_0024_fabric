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
export CORE_PEER_ADDRESS=peer0.org3.example.com:11051
export CORE_PEER_LOCALMSPID=Org3MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
echo_environment
peer channel fetch 0 $CHANNEL_NAME.block -o orderer.example.com:7050 -c $CHANNEL_NAME --tls --cafile $ORDERER_CA


echo "#################################################################"
echo "#######    Channel join peer0.org3.example.com:11051   ###########"
echo "#################################################################"
export CORE_PEER_ADDRESS=peer0.org3.example.com:11051
export CORE_PEER_LOCALMSPID=Org3MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp
echo_environment
peer channel join -b $CHANNEL_NAME.block

echo "#################################################################"
echo "#######    Channel join peer1.org3.example.com:12051   ###########"
echo "#################################################################"
export CORE_PEER_ADDRESS=peer1.org3.example.com:12051
export CORE_PEER_LOCALMSPID=Org3MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/peers/peer1.org3.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp
echo_environment
peer channel join -b $CHANNEL_NAME.block
