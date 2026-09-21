#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get deploy secure-app -n cascade -o jsonpath='{.status.availableReplicas}' 2>/dev/null)
if [ -n "$v" ] && [ "$v" -ge 1 ]; then echo "Success: secure-app has available replicas"; exit 0; else echo "Error: available replicas is '$v', expected >=1"; exit 1; fi
