#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
kubectl $CTX create namespace beta --dry-run=client -o yaml | kubectl $CTX apply -f - || true
kubectl $CTX -n beta delete cronjob report --ignore-not-found=true
echo "Setup complete for Question 7"
exit 0
