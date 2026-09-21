#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get deploy secure-app -n cascade -o jsonpath='{.spec.template.spec.containers[0].securityContext.capabilities.add}' 2>/dev/null)
if [[ "$v" == *"NET_ADMIN"* ]]; then echo "Success: container has NET_ADMIN capability"; exit 0; else echo "Error: capabilities are '$v', expected NET_ADMIN"; exit 1; fi
