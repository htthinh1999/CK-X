#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
a=$(kubectl get ingress rewrite-ingress -n ocean -o jsonpath='{.metadata.annotations.nginx\.ingress\.kubernetes\.io/rewrite-target}' 2>/dev/null)
if [ "$a" = '/$2' ]; then
  echo "Success: rewrite-target annotation is /\$2"; exit 0
fi
echo "Error: rewrite-target is '$a', expected /\$2"; exit 1
