#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX -n dev get pod sidecar-pod >/dev/null 2>&1 || { echo "ERR: pod sidecar-pod not found"; exit 1; }
# app containers + native sidecars (init containers with restartPolicy Always)
c=$(kubectl $CTX -n dev get pod sidecar-pod -o json 2>/dev/null | jq '[.spec.containers[], ((.spec.initContainers // [])[] | select(.restartPolicy == "Always"))] | length')
[ "${c:-0}" -ge 2 ] && { echo "OK: $c containers"; exit 0; }
echo "ERR: $c containers, expected >=2"; exit 1
