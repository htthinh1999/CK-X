#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

# The student must create namespace 'mynamespace' (its existence is scored),
# so ensure a clean state and do NOT pre-create it.
kubectl delete namespace mynamespace --ignore-not-found=true >/dev/null 2>&1 || true

echo "Setup complete for Question 3"
exit 0
