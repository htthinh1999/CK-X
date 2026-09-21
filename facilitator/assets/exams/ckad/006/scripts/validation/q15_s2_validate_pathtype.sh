#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get ingress api-ingress -n default -o jsonpath='{.spec.rules[0].http.paths[0].pathType}' 2>/dev/null)
if [ "$v" = "Prefix" ] || [ "$v" = "Exact" ] || [ "$v" = "ImplementationSpecific" ]; then echo "Success: pathType '$v' is valid"; exit 0; else echo "Error: pathType is '$v', expected Prefix/Exact/ImplementationSpecific"; exit 1; fi
