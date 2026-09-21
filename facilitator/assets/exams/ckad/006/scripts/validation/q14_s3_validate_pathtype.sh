#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get ingress web-ingress -n eddy -o jsonpath='{.spec.rules[0].http.paths[0].pathType}' 2>/dev/null)
if [ "$v" = "Prefix" ]; then echo "Success: pathType is Prefix"; exit 0; else echo "Error: pathType is '$v', expected Prefix"; exit 1; fi
