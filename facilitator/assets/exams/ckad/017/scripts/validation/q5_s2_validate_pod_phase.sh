#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
img=$(kubectl get pod backend-pod -n wave -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
state=$(kubectl get pod backend-pod -n wave -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$img" = "nginx:alpine" ] && { [ "$state" = "Running" ] || [ "$state" = "Pending" ]; }; then
  echo "Success: pod not in ErrImagePull (phase=$state)"; exit 0
fi
echo "Error: pod phase '$state' with image '$img'"; exit 1
