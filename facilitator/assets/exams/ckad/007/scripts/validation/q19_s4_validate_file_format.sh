#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if grep -q "deployments" "/tmp/exam/course/19/permissions.txt" 2>/dev/null; then echo "Success: documents deployments"; exit 0; else echo "Error: documents deployments - not found"; exit 1; fi
