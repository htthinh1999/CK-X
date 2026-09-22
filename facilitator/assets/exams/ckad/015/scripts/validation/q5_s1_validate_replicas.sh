#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
dep=$(kubectl get deploy -n typhoon -o name 2>/dev/null | grep storm-app | head -n 1)
[ -n "$dep" ] || { echo "Error: storm-app deployment not found in typhoon"; exit 1; }
reps=$(kubectl get "$dep" -n typhoon -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$reps" == "3" ]; then
  echo "Success: replicas=3"
  exit 0
else
  echo "Error: replicas='$reps' (expected 3)"
  exit 1
fi
