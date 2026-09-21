#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get ingress path-ingress -n poseidon -o jsonpath='{.spec.rules[0].http.paths[?(@.path=="/api")].backend.service.name}' 2>/dev/null)
if [ "$v" = "api-svc" ]; then echo "Success: /api routes to api-svc"; exit 0; else echo "Error: /api backend is '$v', expected api-svc"; exit 1; fi
