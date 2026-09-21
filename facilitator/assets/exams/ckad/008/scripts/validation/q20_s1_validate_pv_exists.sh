#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

if kubectl get pv myvolume >/dev/null 2>&1; then
  echo "Success: pv myvolume exists"; exit 0
else
  echo "Error: pv myvolume not found"; exit 1
fi
