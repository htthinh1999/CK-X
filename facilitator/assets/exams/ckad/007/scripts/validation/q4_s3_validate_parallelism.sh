#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get job parallel-processor -n current -o jsonpath='{.spec.parallelism}' 2>/dev/null)
if [ "$val" = "3" ]; then echo "Success: parallelism is 3"; exit 0; else echo "Error: parallelism is '$val', expected 3"; exit 1; fi
