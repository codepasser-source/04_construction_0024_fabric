#!/bin/bash
rm -rf fabric-course.tar.gz
tar cvf fabric-course.tar.gz 0001
scp -P 220 fabric-course.tar.gz root@192.168.4.143:/data/src/github.com/hyperledger/fabric-course