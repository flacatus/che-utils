#!/bin/sh

if [ -z "${1}" ]; then
	MEMORY=6
else
	MEMORY=${1}
fi

minishift start --memory ${MEMORY}GB --disk-size=30GB --docker-opt userland-proxy=false

oc login -u system:admin --insecure-skip-tls-verify=true
oc adm policy add-cluster-role-to-user cluster-admin developer
oc delete project myproject
oc login --username=developer --password=any --insecure-skip-tls-verify=true
