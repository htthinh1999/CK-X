#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
k=$(kubectl get deployment spread-deploy -n blaze -o jsonpath='{.spec.template.spec.topologySpreadConstraints[0].topologyKey}' 2>/dev/null)
if [ "$k" = "kubernetes.io/hostname" ]; then
  echo "Success: topologyKey kubernetes.io/hostname"
  exit 0
else
  echo "Error: topologyKey is '$k', expected kubernetes.io/hostname"
  exit 1
fi
