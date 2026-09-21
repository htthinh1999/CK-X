#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
t=$(kubectl get service web-svc -n flame -o jsonpath='{.spec.ports[?(@.port==443)].targetPort}' 2>/dev/null)
if [ "$t" = "https-web" ]; then
  echo "Success: port 443 -> https-web"
  exit 0
else
  echo "Error: port 443 targetPort is '$t', expected https-web"
  exit 1
fi
