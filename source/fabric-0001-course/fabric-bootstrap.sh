#!/bin/bash
echo
echo " ____    _____      _      ____    _____ "
echo "/ ___|  |_   _|    / \    |  _ \  |_   _|"
echo "\___ \    | |     / _ \   | |_) |   | |  "
echo " ___) |   | |    / ___ \  |  _ <    | |  "
echo "|____/    |_|   /_/   \_\ |_| \_\   |_|  "
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

# Generating Orderer Genesis block [Solo]
./fabric-bootstrap-configtx-genesis-solo.sh

# Generating channel configuration transaction 'channel.tx'
./fabric-bootstrap-configtx-channel.sh

# Generating anchor peer update
./fabric-bootstrap-configtx-anchors.sh

# Docker compose up
./fabric-docker-up.sh
