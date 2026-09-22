#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -s "/tmp/exam/course/18/dns.txt" ]; then
  echo "Success: dns.txt saved"
  exit 0
else
  echo "Error: dns.txt not found or empty"
  exit 1
fi
