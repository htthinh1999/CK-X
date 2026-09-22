#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX -n dev get deployment flags-app >/dev/null 2>&1 || { echo "ERR: deployment flags-app not found"; exit 1; }
vol=$(kubectl $CTX -n dev get deployment flags-app -o jsonpath='{.spec.template.spec.volumes[*].configMap.name}' 2>/dev/null)
mp=$(kubectl $CTX -n dev get deployment flags-app -o jsonpath='{.spec.template.spec.containers[0].volumeMounts[*].mountPath}' 2>/dev/null)
echo "$vol" | grep -q "feature-flags" && echo "$mp" | grep -q "/etc/flags" && { echo "OK: cm mounted at /etc/flags"; exit 0; }
echo "ERR: cm volume=$vol mounts=$mp (expected feature-flags at /etc/flags)"; exit 1
