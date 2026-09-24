#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get svc web-svc -n shoal -o jsonpath='{.spec.selector.app}' 2>/dev/null)
if [ "$v" = "webapp" ]; then echo "Success: service selector is app=webapp"; exit 0; else echo "Error: selector app is '$v', expected webapp"; exit 1; fi
