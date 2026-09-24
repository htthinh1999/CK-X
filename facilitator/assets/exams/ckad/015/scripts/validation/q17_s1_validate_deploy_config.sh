#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl get deploy cyclone-web -n cyclone >/dev/null 2>&1 || { echo "Error: Deployment cyclone-web not found in cyclone"; exit 1; }
rev=$(kubectl get deploy cyclone-web -n cyclone -o jsonpath='{.spec.revisionHistoryLimit}' 2>/dev/null)
img=$(kubectl get deploy cyclone-web -n cyclone -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [ "$rev" == "2" ] && [ "$img" == "nginx:1.23.1" ]; then
  echo "Success: revisionHistoryLimit=2 and image nginx:1.23.1"
  exit 0
else
  echo "Error: revisionHistoryLimit='$rev' image='$img' (expected 2 / nginx:1.23.1)"
  exit 1
fi
