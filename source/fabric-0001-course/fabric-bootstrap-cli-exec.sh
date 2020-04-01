#!/bin/bash
echo
echo "'########:'##::::'##::'######::'########:"
echo " ##.....::. ##::'##::'##... ##: ##.....::"
echo " ##::::::::. ##'##::: ##:::..:: ##:::::::"
echo " ######:::::. ###:::: ##::::::: ######:::"
echo " ##...:::::: ## ##::: ##::::::: ##...::::"
echo " ##:::::::: ##:. ##:: ##::: ##: ##:::::::"
echo " ########: ##:::. ##:. ######:: ########:"
echo "........::..:::::..:::......:::........::"
echo
echo "Exec fabric course"
echo
# Channel create & join & update anchors
docker exec cli ./scripts/cli-peer-channel.sh

# Chaincode install & instantiate
docker exec cli ./scripts/cli-peer-chaincode.sh
