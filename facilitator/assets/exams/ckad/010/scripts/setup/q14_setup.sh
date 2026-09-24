#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"


command -v helm >/dev/null 2>&1 || echo 'Note: helm expected on jumphost'

# Start without a `bitnami` repo so the student really has to add it. Helm's repo
# config lives in this server's home directory and survives between exams, so an
# earlier lab's setup may have left one behind.
helm repo remove bitnami >/dev/null 2>&1 || true

echo "Setup complete for Question 14"
exit 0
