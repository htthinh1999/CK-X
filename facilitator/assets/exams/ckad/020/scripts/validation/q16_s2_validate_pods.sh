#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
pods=$(kubectl get resourcequota priority-quota -n eden -o jsonpath='{.spec.hard.pods}' 2>/dev/null)
if [ "$pods" = "5" ]; then
  echo "Success: hard pods limit is 5"
  exit 0
fi
echo "Error: hard pods limit is '$pods', expected 5"
exit 1
