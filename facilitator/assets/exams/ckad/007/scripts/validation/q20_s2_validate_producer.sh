#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if kubectl get pod data-pipeline -n anchor -o jsonpath='{.spec.containers[*].name}' 2>/dev/null | grep -q "producer"; then echo "Success: producer container"; exit 0; else echo "Error: producer container - not found"; exit 1; fi
