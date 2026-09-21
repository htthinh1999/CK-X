#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl get pod stealth-pod -n siege >/dev/null 2>&1 && { echo "Success: pod stealth-pod exists"; exit 0; }
echo "Error: pod stealth-pod not found"; exit 1
