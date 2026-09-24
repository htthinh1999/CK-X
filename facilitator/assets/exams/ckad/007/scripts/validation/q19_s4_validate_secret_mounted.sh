#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get pod secret-consumer -n deep -o jsonpath='{.spec.volumes[*].secret.secretName}' 2>/dev/null | grep -q "app-credentials"; then echo "Success: secret mounted"; exit 0; else echo "Error: secret mounted - not found"; exit 1; fi
