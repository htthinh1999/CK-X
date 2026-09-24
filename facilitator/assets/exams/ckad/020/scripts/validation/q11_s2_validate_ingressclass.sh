#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
ic=$(kubectl get ingress cosmos-ingress -n cosmos -o jsonpath='{.spec.ingressClassName}' 2>/dev/null)
if [ "$ic" = "nginx" ]; then
  echo "Success: ingressClassName is nginx"
  exit 0
fi
echo "Error: ingressClassName is '$ic', expected nginx"
exit 1
