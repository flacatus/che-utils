#!/bin/bash

set -e -x

init() {
  SecretFile=/home/flaxius/Documents/crc-credentials/pull-secret.txt
  CPUS=5
  RAM_MEMORY=16000
}

installCRCLocally() {
  sudo systemctl start libvirtd
  crc setup
  crc start --cpus=${CPUS} --memory=${RAM_MEMORY} --pull-secret-file=${SecretFile}
}

getKubeAdminPassword() {
  cat ~/.crc/cache/*/kubeadmin-password
}

init
installCRCLocally

eval $( crc oc-env )
oc login -u kubeadmin -p $( getKubeadminPassword ) https://api.crc.testing:6443
