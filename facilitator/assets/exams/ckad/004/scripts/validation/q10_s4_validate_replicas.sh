#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get deployment annotated-app -n olympus -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$v" = "2" ]; then echo "Success: replicas 2"; exit 0; else echo "Error: replicas is '$v', expected 2"; exit 1; fi
