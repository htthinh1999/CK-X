#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
val=$(kubectl get svc app -n grain -o jsonpath='{.spec.selector.app}' 2>/dev/null)
if [ "$val" = "myapp" ]; then
  echo "Success: service app selector app=myapp"
  exit 0
else
  echo "Error: service app selector incorrect (got '$val')"
  exit 1
fi
