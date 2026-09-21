#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl get pod entry-override -n fortress >/dev/null 2>&1 && { echo "Success: pod entry-override exists"; exit 0; }
echo "Error: pod entry-override not found in fortress"; exit 1
