#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
f="/tmp/exam/course/1/Dockerfile"
if [ -f "$f" ]; then echo "Success: Dockerfile exists"; exit 0; fi
echo "Error: $f not found"; exit 1
