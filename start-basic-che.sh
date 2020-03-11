#!/bin/sh

BASE_DIR=$(cd "$(dirname "$0")" && pwd)
NAMESPACE=che

init() {
    kubectl create namespace ${NAMESPACE}
    kubectl apply -n ${NAMESPACE} -f https://raw.githubusercontent.com/eclipse/che-operator/master/deploy/cluster_role.yaml
    kubectl apply -n ${NAMESPACE} -f https://raw.githubusercontent.com/eclipse/che-operator/master/deploy/cluster_role_binding.yaml
    kubectl apply -n ${NAMESPACE} -f https://raw.githubusercontent.com/eclipse/che-operator/master/deploy/role.yaml
    kubectl apply -n ${NAMESPACE} -f https://raw.githubusercontent.com/eclipse/che-operator/master/deploy/role_binding.yaml
}

run_service() {
    kubectl apply -n ${NAMESPACE} -f https://raw.githubusercontent.com/eclipse/che-operator/master/deploy/service_account.yaml
    kubectl apply -n ${NAMESPACE} -f https://raw.githubusercontent.com/eclipse/che-operator/master/deploy/crds/org_v1_che_crd.yaml
    kubectl apply -n ${NAMESPACE} -f https://raw.githubusercontent.com/eclipse/che-operator/master/deploy/operator.yaml
    kubectl apply -n ${NAMESPACE} -f ${BASE_DIR}/custom/orgv1.yaml

}
minikube addons enable ingress
sleep 60
init
run_service

JSONPATH='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}'; until kubectl -n default get pods -lk8s-app=che -o jsonpath="$JSONPATH" 2>&1 | grep -q "Ready=True"; do sleep 1;echo "waiting for kube-dns to be available"; kubectl get pods --all-namespaces; done
