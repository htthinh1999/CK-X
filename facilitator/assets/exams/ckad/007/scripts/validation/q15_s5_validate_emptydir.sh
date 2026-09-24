#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod data-pipeline -n anchor -o jsonpath='{.spec.volumes[*].emptyDir}' 2>/dev/null | grep -q "{}"; then echo "Success: emptyDir volume"; exit 0; else echo "Error: emptyDir volume - not found"; exit 1; fi
