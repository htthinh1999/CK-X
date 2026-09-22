#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX -n alpha get svc cache-svc >/dev/null 2>&1 && { echo "OK: svc exists"; exit 0; }
echo "ERR: service cache-svc not found"; exit 1
