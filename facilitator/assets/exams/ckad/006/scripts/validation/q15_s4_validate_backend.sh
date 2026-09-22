#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get ingress api-ingress -n default -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.name}' 2>/dev/null)
if [ "$v" = "api-svc" ]; then echo "Success: backend is api-svc"; exit 0; else echo "Error: backend is '$v', expected api-svc"; exit 1; fi
