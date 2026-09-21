#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get deploy web-app -n default -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$v" = "8" ]; then echo "Success: web-app has 8 replicas"; exit 0; else echo "Error: web-app replicas is '$v', expected 8"; exit 1; fi
