#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX create namespace alpha --dry-run=client -o yaml | kubectl $CTX apply -f - || true
kubectl $CTX -n alpha delete pod pinned --ignore-not-found=true
# Label a worker node so the student can target it with a nodeSelector.
worker=$(kubectl $CTX get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | grep -i agent | head -1)
[ -z "$worker" ] && worker=$(kubectl $CTX get nodes -o jsonpath='{.items[0].metadata.name}')
[ -n "$worker" ] && kubectl $CTX label node "$worker" disk=ssd --overwrite || true
echo "Setup complete for Question 6"
exit 0
