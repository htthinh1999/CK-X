#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if ! kubectl get pod wisdom-server -n harmony >/dev/null 2>&1; then
  echo "Error: pod wisdom-server not found in harmony"; exit 1
fi
img=$(kubectl get pod wisdom-server -n harmony -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
if [[ "$img" == *"benzaiten-wisdom"* ]]; then
  echo "Success: pod wisdom-server uses image $img"; exit 0
fi
echo "Error: pod image '$img' does not contain benzaiten-wisdom"; exit 1
