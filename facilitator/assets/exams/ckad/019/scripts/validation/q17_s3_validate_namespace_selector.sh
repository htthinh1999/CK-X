#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
ns=$(kubectl get netpol protect-db -n vanguard -o jsonpath='{.spec.ingress[*].from[*].namespaceSelector.matchLabels}' 2>/dev/null)
case "$ns" in *kubernetes.io/metadata.name*) echo "Success: namespaceSelector uses kubernetes.io/metadata.name"; exit 0;; esac
echo "Error: namespaceSelector matchLabels '$ns' missing kubernetes.io/metadata.name"; exit 1
