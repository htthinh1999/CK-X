#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get deployment rolling-app -n pounce -o jsonpath='{.spec.paused}' 2>/dev/null)
if [ "$v" != "true" ]; then echo "Success: deployment not paused"; exit 0; else echo "Error: deployment is paused"; exit 1; fi
