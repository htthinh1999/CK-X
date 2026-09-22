#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
F=/tmp/exam/course/1/Dockerfile
if [ -f "$F" ] && grep -q "FROM alpine:3.18" "$F"; then
  echo "Success: alpine:3.18 stage defined"
  exit 0
else
  echo "Error: FROM alpine:3.18 not found"
  exit 1
fi
