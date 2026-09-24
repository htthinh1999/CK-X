#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
F=/tmp/exam/course/2/Dockerfile
if [ -f "$F" ] && { grep -q "AS builder" "$F" || grep -q "as builder" "$F"; }; then
  echo "Success: builder stage found in Dockerfile"; exit 0
fi
echo "Error: builder stage not found in $F"; exit 1
