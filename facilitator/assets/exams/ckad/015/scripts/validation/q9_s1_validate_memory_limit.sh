#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl get pod memory-hog -n mistral >/dev/null 2>&1 || { echo "Error: Pod memory-hog not found in mistral"; exit 1; }
lim=$(kubectl get pod memory-hog -n mistral -o jsonpath='{.spec.containers[0].resources.limits.memory}' 2>/dev/null)
if [ "$lim" == "256Mi" ]; then
  echo "Success: memory limit is 256Mi"
  exit 0
else
  echo "Error: memory limit='$lim' (expected 256Mi)"
  exit 1
fi
