#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get ingress path-ingress -n poseidon -o jsonpath='{.spec.rules[0].http.paths[?(@.path=="/web")].backend.service.name}' 2>/dev/null)
if [ "$v" = "web-svc" ]; then echo "Success: /web routes to web-svc"; exit 0; else echo "Error: /web backend is '$v', expected web-svc"; exit 1; fi
