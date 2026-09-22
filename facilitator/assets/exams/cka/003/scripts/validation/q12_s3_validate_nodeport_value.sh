#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
np=$(kubectl $CTX -n beta get svc api-np -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null)
[ "$np" = "30081" ] && { echo "OK: nodePort 30081"; exit 0; }
echo "ERR: nodePort=$np, expected 30081"; exit 1
