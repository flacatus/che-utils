#!/bin/bash

getKubeadminPassword() {
  cat ~/.crc/cache/*/kubeadmin-password
}

set -x
set -e

sudo systemctl start libvirtd
sleep 1
crc start --memory 12288 --pull-secret-file ~/.crc/pull-secret
sleep 3
eval $( crc oc-env )
sleep 3
oc login -u kubeadmin -p $( getKubeadminPassword ) https://api.crc.testing:6443

