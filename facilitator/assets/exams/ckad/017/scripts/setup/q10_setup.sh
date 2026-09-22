#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace depths --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/10
# Generate Warning events in the depths namespace (failing image pull)
kubectl run failing-pod --image=wrong-image-for-event -n depths >/dev/null 2>&1 || true
echo "Setup complete for Question 10"
exit 0
