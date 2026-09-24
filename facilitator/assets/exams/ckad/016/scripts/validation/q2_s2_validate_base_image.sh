#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
f="/tmp/exam/course/2/Dockerfile"
if [ -f "$f" ] && grep -q "FROM nginx:1.23-alpine" "$f"; then
  echo "Success: base image nginx:1.23-alpine"; exit 0
fi
echo "Error: base image FROM nginx:1.23-alpine not found"; exit 1
