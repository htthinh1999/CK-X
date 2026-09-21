#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
grace=$(kubectl get pod graceful-shutdown -n ancient -o jsonpath='{.spec.terminationGracePeriodSeconds}' 2>/dev/null)
if [ "$grace" = "45" ]; then
  echo "Success: terminationGracePeriodSeconds is 45"
  exit 0
fi
echo "Error: terminationGracePeriodSeconds is '$grace', expected 45"
exit 1
