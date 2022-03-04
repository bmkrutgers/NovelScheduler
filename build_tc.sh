#!/bin/bash

sudo apt-get install libdb-dev

git submodule update --init --recursive

cd iproute2
./configure
cd ..

cp q_fq_new.c iproute2/tc/

cd iproute2
make TCSO=q_fq_new.so

echo "TC_LIB_DIR=$pwd/tc"
