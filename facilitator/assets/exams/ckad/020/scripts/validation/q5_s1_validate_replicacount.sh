#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if ! helm status genesis-web -n nexus >/dev/null 2>&1; then
  echo "Error: helm release genesis-web not found in nexus"
  exit 1
fi
reps=$(helm get values genesis-web -n nexus -a 2>/dev/null | grep -A 0 'replicaCount:' | awk '{print $2}')
if [ "$reps" = "3" ]; then
  echo "Success: replicaCount is 3"
  exit 0
fi
echo "Error: replicaCount is '$reps', expected 3"
exit 1
