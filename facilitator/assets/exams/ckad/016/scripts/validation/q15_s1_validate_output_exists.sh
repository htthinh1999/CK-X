#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
f="/tmp/exam/course/15/output.yaml"
if [ -f "$f" ]; then echo "Success: output.yaml exists"; exit 0; fi
echo "Error: $f not found"; exit 1
