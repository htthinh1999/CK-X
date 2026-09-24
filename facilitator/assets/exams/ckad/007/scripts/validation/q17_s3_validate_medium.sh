#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod cache-pod -n reef -o jsonpath='{.spec.volumes[*].emptyDir.medium}' 2>/dev/null | grep -q "Memory"; then echo "Success: emptyDir medium Memory"; exit 0; else echo "Error: emptyDir medium Memory - not found"; exit 1; fi
