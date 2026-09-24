#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX -n alpha get serviceaccount deployer >/dev/null 2>&1 && { echo "OK: sa deployer"; exit 0; }
echo "ERR: serviceaccount deployer not found"; exit 1
