#!/usr/bin/env bash

TMP_SETUP_DIR="tmp/docker-setup"
CURRENT_PWD=$PWD

if [ ! -d $TMP_SETUP_DIR ]
  then
    mkdir -p $TMP_SETUP_DIR
fi

cd $TMP_SETUP_DIR

git clone --depth 1 git@github.com:micron/docker-setup.git .

rsync -rv --ignore-existing --exclude=./init.sh . $CURRENT_PWD/