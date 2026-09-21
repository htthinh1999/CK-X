#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
f="/tmp/exam/course/5/output.yaml"
if [ -f "$f" ]; then echo "Success: output.yaml exists"; exit 0; fi
echo "Error: $f not found"; exit 1
