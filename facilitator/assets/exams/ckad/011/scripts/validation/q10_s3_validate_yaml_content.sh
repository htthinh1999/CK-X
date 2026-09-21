#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
f="/tmp/exam/course/10/pod.yaml"
if [ -s "$f" ] && grep -q "kind: Pod" "$f" 2>/dev/null && grep -q "inspect-pod" "$f" 2>/dev/null; then
  echo "Success: YAML contains Pod definition for inspect-pod"
  exit 0
else
  echo "Error: YAML does not contain expected Pod definition for inspect-pod"
  exit 1
fi
