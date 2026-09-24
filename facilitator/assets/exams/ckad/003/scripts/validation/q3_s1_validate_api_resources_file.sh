#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
file="/tmp/exam/course/3/api-resources"
if [ -f "$file" ] && grep -qE "NAME.*SHORTNAMES|pods.*po|deployments.*deploy" "$file" 2>/dev/null; then
  echo "Success: api-resources file present with resource list"
  exit 0
else
  echo "Error: /tmp/exam/course/3/api-resources missing or does not contain an API resources list"
  exit 1
fi
