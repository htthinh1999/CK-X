#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX -n prod get pod secret-consumer >/dev/null 2>&1 || { echo "ERR: pod secret-consumer not found"; exit 1; }
vol=$(kubectl $CTX -n prod get pod secret-consumer -o jsonpath='{.spec.volumes[*].secret.secretName}' 2>/dev/null)
mp=$(kubectl $CTX -n prod get pod secret-consumer -o jsonpath='{.spec.containers[0].volumeMounts[*].mountPath}' 2>/dev/null)
echo "$vol" | grep -q "app-secret" && echo "$mp" | grep -q "/etc/secret" && { echo "OK"; exit 0; }
echo "ERR: vol=$vol mounts=$mp"; exit 1
