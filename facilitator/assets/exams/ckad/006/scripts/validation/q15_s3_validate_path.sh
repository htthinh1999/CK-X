#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get ingress api-ingress -n default -o jsonpath='{.spec.rules[0].http.paths[0].path}' 2>/dev/null)
if [ "$v" = "/api" ]; then echo "Success: path is /api"; exit 0; else echo "Error: path is '$v', expected /api"; exit 1; fi
