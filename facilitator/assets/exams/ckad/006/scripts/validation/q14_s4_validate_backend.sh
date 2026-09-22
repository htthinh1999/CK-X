#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
svc=$(kubectl get ingress web-ingress -n eddy -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.name}' 2>/dev/null)
port=$(kubectl get ingress web-ingress -n eddy -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.port.number}' 2>/dev/null)
if [ "$svc" = "web-svc" ] && [ "$port" = "8080" ]; then echo "Success: backend is web-svc:8080"; exit 0; else echo "Error: backend is '$svc:$port', expected web-svc:8080"; exit 1; fi
