#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
s=$(kubectl get ingress secure-ingress -n solstice -o jsonpath='{.spec.tls[0].secretName}' 2>/dev/null)
h=$(kubectl get ingress secure-ingress -n solstice -o jsonpath='{.spec.tls[0].hosts[0]}' 2>/dev/null)
if [ "$s" = "secure-tls" ] && [ "$h" = "secure.example.com" ]; then
  echo "Success: TLS secure-tls for secure.example.com"
  exit 0
else
  echo "Error: tls secret='$s' host='$h'"
  exit 1
fi
