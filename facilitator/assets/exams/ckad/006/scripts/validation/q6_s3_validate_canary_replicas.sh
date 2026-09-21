#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get deploy web-app-canary -n default -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$v" = "2" ]; then echo "Success: canary has 2 replicas"; exit 0; else echo "Error: canary replicas is '$v', expected 2"; exit 1; fi
