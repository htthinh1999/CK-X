#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
f="/tmp/exam/course/15/output.yaml"
if [ -f "$f" ] && grep -q "replicas: 3" "$f"; then echo "Success: replicas: 3 present"; exit 0; fi
echo "Error: 'replicas: 3' not found in output.yaml"; exit 1
