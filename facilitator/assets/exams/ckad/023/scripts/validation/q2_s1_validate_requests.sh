#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
cpu=$(kubectl $CTX -n dev get pod limited -o jsonpath='{.spec.containers[0].resources.requests.cpu}' 2>/dev/null)
mem=$(kubectl $CTX -n dev get pod limited -o jsonpath='{.spec.containers[0].resources.requests.memory}' 2>/dev/null)
[ "$cpu" = "100m" ] && [ "$mem" = "64Mi" ] && { echo "OK: requests 100m/64Mi"; exit 0; }
echo "ERR: requests cpu=$cpu mem=$mem, expected 100m/64Mi"; exit 1
