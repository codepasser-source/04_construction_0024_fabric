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
}

echo "#################################################################"
echo "#######    Chaincode install peer0.org1.example.com:7051   ######"
echo "#################################################################"
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
echo_environment
# this installs the Go chaincode. For go chaincode -p takes the relative path from $GOPATH/src
peer chaincode install -n fabcar -v 1.0 -p github.com/chaincode/fabcar/go/
peer chaincode list --installed

echo "#################################################################"
echo "#######    Chaincode install peer1.org1.example.com:8051   ######"
echo "#################################################################"
export CORE_PEER_ADDRESS=peer1.org1.example.com:8051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
echo_environment
peer chaincode install -n fabcar -v 1.0 -p github.com/chaincode/fabcar/go/
peer chaincode list --installed

echo "#################################################################"
echo "#######    Chaincode install peer0.org2.example.com:9051    #####"
echo "#################################################################"
export CORE_PEER_ADDRESS=peer0.org2.example.com:9051
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
echo_environment
peer chaincode install -n fabcar -v 1.0 -p github.com/chaincode/fabcar/go/
peer chaincode list --installed

echo "#################################################################"
echo "#######    Chaincode install peer1.org2.example.com:10051   #####"
echo "#################################################################"
export CORE_PEER_ADDRESS=peer1.org2.example.com:10051
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
echo_environment
peer chaincode install -n fabcar -v 1.0 -p github.com/chaincode/fabcar/go/
peer chaincode list --installed

echo "#################################################################"
echo "#######    Chaincode instantiate orderer.example.com:7050    ####"
echo "#################################################################"
export CHANNEL_NAME=fabric-course
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
echo_environment
peer chaincode instantiate -o orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C $CHANNEL_NAME -n fabcar -v 1.0 -c '{"Args":[]}' -P "AND ('Org1MSP.peer','Org2MSP.peer')"
peer chaincode list --instantiated -C $CHANNEL_NAME
