#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX -n alpha get pod config-reader >/dev/null 2>&1 || { echo "ERR: pod config-reader not found"; exit 1; }
ef=$(kubectl $CTX -n alpha get pod config-reader -o jsonpath='{.spec.containers[0].envFrom[*].configMapRef.name}' 2>/dev/null)
ev=$(kubectl $CTX -n alpha get pod config-reader -o jsonpath='{.spec.containers[0].env[*].valueFrom.configMapKeyRef.name}' 2>/dev/null)
echo "$ef $ev" | grep -q "app-config" && { echo "OK: pod consumes app-config"; exit 0; }
echo "ERR: pod config-reader does not reference configmap app-config"; exit 1
