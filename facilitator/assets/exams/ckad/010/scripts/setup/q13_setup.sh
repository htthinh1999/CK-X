#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"


command -v helm >/dev/null 2>&1 || echo 'Note: helm expected on jumphost'

echo "Setup complete for Question 13"
exit 0
