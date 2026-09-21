#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
n=$(kubectl get ingress api-ingress -n citadel -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.name}' 2>/dev/null)
p=$(kubectl get ingress api-ingress -n citadel -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.port.number}' 2>/dev/null)
if [ "$n" = "api-svc" ] && [ "$p" = "80" ]; then echo "Success: backend api-svc:80"; exit 0
else echo "Error: backend got name=$n port=$p, expected api-svc:80"; exit 1; fi
