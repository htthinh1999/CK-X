#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pod private-app -n hera -o jsonpath='{.spec.imagePullSecrets[0].name}' 2>/dev/null)
if [ "$v" = "registry-creds" ]; then echo "Success: imagePullSecret configured"; exit 0; else echo "Error: imagePullSecret is '$v', expected registry-creds"; exit 1; fi
