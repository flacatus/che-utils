#!/bin/sh

if ! which minikube 
then
    printf "[ERROR] Minikube installation are required."
    exit 1
fi

if [ -z "${1}" ]; then
	MEMORY=8192
else
	MEMORY=${1}
fi

minikube start --memory=${MEMORY} --vm--driver=kvm
