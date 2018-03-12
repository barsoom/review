#!/bin/bash

set -e

if [ ! -d $INSTALL_PATH/sysconfcpus/bin ]; then
  git clone https://github.com/obmarg/libsysconfcpus.git
  cd libsysconfcpus
  ./configure --prefix=$INSTALL_PATH/sysconfcpus
  make && make install
  cd ..
fi

# Fetch and compile dependencies and application code (and include testing tools)
cd $HOME/$CIRCLE_PROJECT_REPONAME
script/bootstrap
