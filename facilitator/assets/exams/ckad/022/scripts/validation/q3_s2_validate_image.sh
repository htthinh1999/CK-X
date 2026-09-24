#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
image=$(kubectl get pod musashi-pod -n apex -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
if [ "$image" = "localhost:5000/musashi-app:v1" ]; then
  echo "Success: image is localhost:5000/musashi-app:v1"
  exit 0
fi
echo "Error: image is '$image', expected localhost:5000/musashi-app:v1"
exit 1
