#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -s "/tmp/exam/course/14/values.txt" ]; then
  echo "Success: values.txt saved"
  exit 0
else
  echo "Error: values.txt not found or empty"
  exit 1
fi
