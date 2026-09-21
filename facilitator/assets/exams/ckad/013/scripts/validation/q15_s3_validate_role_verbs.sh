#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
y=$(kubectl get role deploy-role -n zenith -o yaml 2>/dev/null)
if echo "$y" | grep -q "deployments" && echo "$y" | grep -q "list" && echo "$y" | grep -q "create"; then
  echo "Success: role grants correct verbs on deployments"; exit 0
else
  echo "Error: role verbs/resources incorrect"; exit 1
fi
