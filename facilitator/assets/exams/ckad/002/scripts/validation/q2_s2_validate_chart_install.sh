#!/bin/bash

# Check if Helm is installed
if ! command -v helm &> /dev/null; then
  echo "❌ Helm is not available on this system"
  exit 1
fi

# Check if Bitnami repository is added
REPO_EXISTS=$(helm repo list | grep bitnami | wc -l)
if [[ "$REPO_EXISTS" -eq 0 ]]; then
  echo "❌ Bitnami repository is not added to Helm"
  exit 1
fi

# Check if the nginx chart is installed
RELEASE_EXISTS=$(helm list -n helm-basics | grep nginx-release | wc -l)
if [[ "$RELEASE_EXISTS" -eq 0 ]]; then
  echo "❌ nginx chart is not installed in the 'helm-basics' namespace"
  exit 1
fi

# Check if pods related to the release are running
PODS_RUNNING=$(kubectl get pods -n helm-basics -l app.kubernetes.io/instance=nginx-release | grep Running | wc -l)
if [[ "$PODS_RUNNING" -eq 0 ]]; then
  echo "❌ No pods from the nginx release are running"
  exit 1
fi

echo "✅ Helm chart 'nginx' is installed correctly in the 'helm-basics' namespace"
exit 0 