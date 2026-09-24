#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get job parallel-processor -n current -o jsonpath='{.spec.template.spec.containers[0].name}' 2>/dev/null)
if [ "$val" = "processor" ]; then echo "Success: container name is processor"; exit 0; else echo "Error: container name is '$val', expected processor"; exit 1; fi
