#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if [ -s "/tmp/exam/course/20/token.txt" ]; then
  echo "Success: token.txt saved"
  exit 0
else
  echo "Error: token.txt not found or empty"
  exit 1
fi
