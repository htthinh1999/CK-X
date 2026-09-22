#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f "/tmp/exam/course/3/job.yaml" ]; then
  echo "Success: job.yaml saved"
  exit 0
else
  echo "Error: /tmp/exam/course/3/job.yaml not found"
  exit 1
fi
