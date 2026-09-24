#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
dep=$(kubectl get deploy -n typhoon -o name 2>/dev/null | grep storm-app | head -n 1)
[ -n "$dep" ] || { echo "Error: storm-app deployment not found in typhoon"; exit 1; }
img=$(kubectl get "$dep" -n typhoon -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [[ "$img" == *"v2.0.0"* ]]; then
  echo "Success: image tag v2.0.0 in use ($img)"
  exit 0
else
  echo "Error: image='$img' does not contain v2.0.0"
  exit 1
fi
