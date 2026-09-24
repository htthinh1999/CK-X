#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
cpu=$(kubectl $CTX -n dev get pod limited -o jsonpath='{.spec.containers[0].resources.requests.cpu}' 2>/dev/null)
mem=$(kubectl $CTX -n dev get pod limited -o jsonpath='{.spec.containers[0].resources.requests.memory}' 2>/dev/null)
[ "$cpu" = "100m" ] && [ "$mem" = "64Mi" ] && { echo "OK"; exit 0; }
echo "ERR: requests cpu=$cpu mem=$mem"; exit 1
