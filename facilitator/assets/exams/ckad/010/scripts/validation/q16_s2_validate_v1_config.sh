#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
r=$(kubectl get deployment app-v1 -n grain -o jsonpath='{.spec.replicas}' 2>/dev/null)
i=$(kubectl get deployment app-v1 -n grain -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
l=$(kubectl get deployment app-v1 -n grain -o jsonpath='{.spec.template.metadata.labels.app}' 2>/dev/null)
if [ "$r" = "3" ] && [ "$i" = "nginx:1.18.0" ] && [ "$l" = "myapp" ]; then
  echo "Success: app-v1 config correct"
  exit 0
else
  echo "Error: app-v1 config incorrect (replicas=$r image=$i app=$l)"
  exit 1
fi
