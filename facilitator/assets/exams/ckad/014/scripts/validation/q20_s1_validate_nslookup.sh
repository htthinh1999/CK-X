#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
F=/tmp/exam/course/20/nslookup.txt
if [ -f "$F" ] && grep -q "kubernetes.default.svc.cluster.local" "$F"; then
  echo "Success: nslookup output valid"
  exit 0
else
  echo "Error: nslookup.txt missing or missing default service string"
  exit 1
fi
