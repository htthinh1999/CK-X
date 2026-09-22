#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

# Q6 updates the nginx-deploy Deployment created in Q5. Ensure namespace exists;
# the Deployment itself is created by the student in Q5 (its existence is scored).
kubectl create namespace valley --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

echo "Setup complete for Question 6"
exit 0
