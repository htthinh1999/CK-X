#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX -n dev get deployment flags-app >/dev/null 2>&1 || { echo "ERR: deployment flags-app not found"; exit 1; }
vol=$(kubectl $CTX -n dev get deployment flags-app -o jsonpath='{.spec.template.spec.volumes[*].configMap.name}' 2>/dev/null)
mp=$(kubectl $CTX -n dev get deployment flags-app -o jsonpath='{.spec.template.spec.containers[0].volumeMounts[*].mountPath}' 2>/dev/null)
echo "$vol" | grep -q "feature-flags" && echo "$mp" | grep -q "/etc/flags" && { echo "OK"; exit 0; }
echo "ERR: vol=$vol mounts=$mp"; exit 1
