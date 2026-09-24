#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
rev=$(helm history web-release -n radiance --max 1 -o json 2>/dev/null | grep -o '"revision":[0-9]*' | head -1 | grep -o '[0-9]*')
if [ -n "$rev" ] && [ "$rev" -ge 2 ]; then
  echo "Success: revision is $rev (>=2)"
  exit 0
else
  echo "Error: revision is '$rev' (expected >=2)"
  exit 1
fi
