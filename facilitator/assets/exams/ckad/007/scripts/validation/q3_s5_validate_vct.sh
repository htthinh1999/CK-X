#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get statefulset db-cluster -n reef -o jsonpath='{.spec.volumeClaimTemplates[0].metadata.name}' 2>/dev/null | grep -q "data"; then echo "Success: volumeClaimTemplate name data"; exit 0; else echo "Error: volumeClaimTemplate name data - not found"; exit 1; fi
