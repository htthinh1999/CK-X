#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
env=$(kubectl get pod inject-pod -n zenith -o jsonpath='{.spec.containers[0].envFrom}' 2>/dev/null)
vol=$(kubectl get pod inject-pod -n zenith -o jsonpath='{.spec.volumes}' 2>/dev/null)
if [[ "$env" == *"configMapRef"* || "$env" == *"app-config"* || "$vol" == *"secret"* ]]; then
  echo "Success: ConfigMap injected as env or Secret mounted"
  exit 0
fi
echo "Error: ConfigMap/Secret not properly injected"
exit 1
