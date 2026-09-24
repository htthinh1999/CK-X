#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
cm=$(kubectl get pod ambassador-pod -n melody -o jsonpath='{.spec.volumes[?(@.configMap.name=="haproxy-config")].configMap.name}' 2>/dev/null)
if [ "$cm" == "haproxy-config" ]; then
  echo "Success: haproxy-config configmap mounted"; exit 0
fi
echo "Error: haproxy-config configmap not mounted"; exit 1
