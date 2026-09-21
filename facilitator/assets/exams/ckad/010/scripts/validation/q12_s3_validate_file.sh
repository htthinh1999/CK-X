#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if [ -s "/tmp/exam/course/12/pods.txt" ]; then
  echo "Success: pods.txt saved"
  exit 0
else
  echo "Error: pods.txt not found or empty"
  exit 1
fi
