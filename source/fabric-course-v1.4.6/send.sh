#!/bin/bash
tar cvf fabric.tar.gz 0001
scp -P 220 fabric.tar.gz root@192.168.4.143:/data/src/github.com/hyperledger/fabric-course