#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl get netpol allow-dns-egress -n typhoon >/dev/null 2>&1 || { echo "Error: NetworkPolicy allow-dns-egress not found in typhoon"; exit 1; }
port=$(kubectl get netpol allow-dns-egress -n typhoon -o jsonpath='{.spec.egress[0].ports[0].port}' 2>/dev/null)
if [ "$port" == "53" ]; then
  echo "Success: egress port 53 configured"
  exit 0
else
  echo "Error: egress[0].ports[0].port='$port' (expected 53)"
  exit 1
fi
