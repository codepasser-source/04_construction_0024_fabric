#!/bin/bash
echo
echo ":'######::'########::::'###::::'########::'########:"
echo "'##... ##:... ##..::::'## ##::: ##.... ##:... ##..::"
echo " ##:::..::::: ##:::::'##:. ##:: ##:::: ##:::: ##::::"
echo ". ######::::: ##::::'##:::. ##: ########::::: ##::::"
echo ":..... ##:::: ##:::: #########: ##.. ##:::::: ##::::"
echo "'##::: ##:::: ##:::: ##.... ##: ##::. ##::::: ##::::"
echo ". ######::::: ##:::: ##:::: ##: ##:::. ##:::: ##::::"
echo ":......::::::..:::::..:::::..::..:::::..:::::..:::::"
echo
echo "Build fabric course"
echo

# ====================== down

# Docker compose down
./fabric-docker-down.sh
# Docker environment clean
./fabric-docker-clean.sh

# ====================== bootstrap

# Generate certificates
./fabric-bootstrap-crypto-generate.sh

# Generating Orderer Genesis block [Raft]
./fabric-bootstrap-configtx-genesis-raft.sh

# Generating channel configuration transaction 'channel.tx'
./fabric-bootstrap-configtx-channel.sh

# Generating anchor peer update
./fabric-bootstrap-configtx-anchors.sh

# Docker compose up
./fabric-docker-up.sh
