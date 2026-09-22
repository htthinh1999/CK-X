#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
cpu=$(kubectl $CTX -n dev get pod limited -o jsonpath='{.spec.containers[0].resources.limits.cpu}' 2>/dev/null)
mem=$(kubectl $CTX -n dev get pod limited -o jsonpath='{.spec.containers[0].resources.limits.memory}' 2>/dev/null)
[ "$cpu" = "200m" ] && [ "$mem" = "128Mi" ] && { echo "OK"; exit 0; }
echo "ERR: limits cpu=$cpu mem=$mem"; exit 1
