#!/bin/bash

source /root/.profile

cd /tmp/nad

make install

if [ -d /opt/omni ]; then
  find /opt/omni -type d -exec chmod 755 {} \;
fi

