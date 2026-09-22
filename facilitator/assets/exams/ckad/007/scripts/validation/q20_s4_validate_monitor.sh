#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod data-pipeline -n anchor -o jsonpath='{.spec.containers[*].name}' 2>/dev/null | grep -q "monitor"; then echo "Success: monitor container"; exit 0; else echo "Error: monitor container - not found"; exit 1; fi
