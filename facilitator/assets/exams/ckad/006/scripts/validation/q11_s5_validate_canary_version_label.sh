#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get deploy web-app-canary -n default -o jsonpath='{.spec.template.metadata.labels.version}' 2>/dev/null)
if [ "$v" = "v2" ]; then echo "Success: canary has version=v2 label"; exit 0; else echo "Error: canary version label is '$v', expected v2"; exit 1; fi
