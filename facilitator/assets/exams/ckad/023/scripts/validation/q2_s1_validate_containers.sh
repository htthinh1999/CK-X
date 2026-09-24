#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX -n dev get pod sidecar-pod >/dev/null 2>&1 || { echo "ERR: pod sidecar-pod not found"; exit 1; }
c=$(kubectl $CTX -n dev get pod sidecar-pod -o jsonpath='{.spec.containers[*].name}' 2>/dev/null | wc -w)
[ "$c" -ge 2 ] && { echo "OK: $c containers"; exit 0; }
echo "ERR: $c containers, expected >=2"; exit 1
