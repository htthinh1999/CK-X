#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get deploy web-app-canary -n default -o jsonpath='{.spec.template.metadata.labels.app}' 2>/dev/null)
if [ "$v" = "webapp" ]; then echo "Success: canary has app=webapp label"; exit 0; else echo "Error: canary app label is '$v', expected webapp"; exit 1; fi
