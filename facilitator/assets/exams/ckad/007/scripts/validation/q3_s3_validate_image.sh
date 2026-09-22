#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if kubectl get statefulset db-cluster -n reef -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null | grep -q "redis"; then echo "Success: image contains redis"; exit 0; else echo "Error: image contains redis - not found"; exit 1; fi
