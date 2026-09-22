#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
f="/tmp/exam/course/5/output.yaml"
if [ -f "$f" ] && grep -q 'image: "nginx:latest"' "$f"; then echo "Success: image nginx:latest present"; exit 0; fi
echo "Error: 'image: \"nginx:latest\"' not found in output.yaml"; exit 1
