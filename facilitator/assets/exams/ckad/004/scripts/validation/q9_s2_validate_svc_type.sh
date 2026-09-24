#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get svc external-api -n hermes -o jsonpath='{.spec.type}' 2>/dev/null)
if [ "$v" = "ExternalName" ]; then echo "Success: type ExternalName"; exit 0; else echo "Error: type is '$v', expected ExternalName"; exit 1; fi
