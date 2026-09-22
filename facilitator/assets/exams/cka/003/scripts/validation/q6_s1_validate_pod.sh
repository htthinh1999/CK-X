#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX -n alpha get pod pinned >/dev/null 2>&1 && { echo "OK: pod pinned exists"; exit 0; }
echo "ERR: pod pinned not found"; exit 1
