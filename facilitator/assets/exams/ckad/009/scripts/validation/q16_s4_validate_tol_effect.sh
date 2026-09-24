#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

eff=$(kubectl get pod tolerate-pod -n moss -o jsonpath='{.spec.tolerations[?(@.key=="tier")].effect}' 2>/dev/null)
if [ "$eff" = "NoSchedule" ]; then
  echo "Success: toleration effect NoSchedule correct"; exit 0
else
  echo "Error: toleration effect is '$eff', expected NoSchedule"; exit 1
fi
