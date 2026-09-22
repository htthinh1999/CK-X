#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -s "/tmp/exam/course/15/releases.txt" ]; then
  echo "Success: releases.txt saved"
  exit 0
else
  echo "Error: releases.txt not found or empty"
  exit 1
fi
