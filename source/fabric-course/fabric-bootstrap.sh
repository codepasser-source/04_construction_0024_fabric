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

# Generate certificates
./fabric-cryptogen-generate.sh

# Generating Orderer Genesis block [Solo]
./fabric-configtx-genesis-solo.sh

# Generating channel configuration transaction 'channel.tx'
./fabric-configtx-channel.sh

# Generating anchor peer update
./fabric-configtx-anchors.sh
