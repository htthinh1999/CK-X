#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX -n beta get pod db-client >/dev/null 2>&1 || { echo "ERR: pod db-client not found"; exit 1; }
ef=$(kubectl $CTX -n beta get pod db-client -o jsonpath='{.spec.containers[0].envFrom[*].secretRef.name}' 2>/dev/null)
ev=$(kubectl $CTX -n beta get pod db-client -o jsonpath='{.spec.containers[0].env[*].valueFrom.secretKeyRef.name}' 2>/dev/null)
echo "$ef $ev" | grep -q "db-cred" && { echo "OK: pod consumes secret db-cred"; exit 0; }
echo "ERR: pod db-client does not reference secret db-cred"; exit 1
