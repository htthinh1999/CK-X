#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX -n beta get pvc data >/dev/null 2>&1 || { echo "ERR: pvc data not found"; exit 1; }
am=$(kubectl $CTX -n beta get pvc data -o jsonpath='{.spec.accessModes[0]}' 2>/dev/null)
[ "$am" = "ReadWriteOnce" ] && { echo "OK: pvc RWO"; exit 0; }
echo "ERR: accessMode=$am, expected ReadWriteOnce"; exit 1
