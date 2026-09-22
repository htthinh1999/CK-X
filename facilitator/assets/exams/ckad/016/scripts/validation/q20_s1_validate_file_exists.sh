#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
f="/tmp/exam/course/20/response.txt"
if [ -f "$f" ]; then echo "Success: response.txt exists"; exit 0; fi
echo "Error: $f not found"; exit 1
